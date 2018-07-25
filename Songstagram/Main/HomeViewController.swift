//
//  HomeViewController.swift
//  Songstagram
//
//  Created by Song on 2018. 7. 19..
//  Copyright © 2018년 Song. All rights reserved.
//

import UIKit

class HomeViewController: ViewController {

    var medias = [InstaMedia]()
    let keyword = "존맛"
    let pullToRefreshTriggerOffset: CGFloat = 100.0
    let scrollToExtendTriggerOffset: CGFloat = 80.0
    var nextMediaID: String = ""

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var refreshView: RefreshView!
    @IBOutlet var extendView: ExtendView!
    @IBOutlet var backgroundView: UIView!

    class func newInstance() -> HomeViewController {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)

        guard let instance = storyboard.instantiateViewController(withIdentifier: "homeViewController") as? HomeViewController else {
            fatalError()
        }

        return instance
    }

    // MARK: lifcycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "#존맛"
        loadMainData()
        addLogoutButtonItem()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    private func loadMainData() {
        if let token = TokenManager.shared.loadToken() {
            INSTAGRAM_URL.ACCESS_TOKEN = token
            if self.medias.count == 0 {
                loadTagMedias(tag: keyword, isRefresh: false, isExpand: false)
            }
        } else {
            showLogin()
        }
    }

    // MARK: api task

    func loadTagMedias(tag: String, isRefresh: Bool, isExpand: Bool) {

        if !isRefresh, !isExpand {
            LoadingView.begin(target: self.view)
        }

        var nextID: String?

        if isExpand {
            nextID = nextMediaID
        }

        if let url = URL(string: EndPoint.tagMedia(tag: tag.urlEncoding(), lastMediaID: nextID, count: 20).urlString) {
            APIManager.requestURL(url: url, onSuccess: { [weak self] (data) in
                if let jsonString = String(data: data, encoding: String.Encoding.utf8) {
                    guard let jsonData = try! JSONSerialization.jsonObject(with: jsonString.data(using: String.Encoding.utf8)!, options: .allowFragments) as? [String: Any] else {
                        return
                    }

                    DispatchQueue.main.async {
                        if let result = jsonData["meta"] as? [String: Any], let errorCode = result["code"] {
                            if let error = errorCode as? Int, error != 200, let message = result["error_message"] as? String {

                                if error == 400 { //token expired
                                    TokenManager.shared.clear()
                                    let loginViewController = LoginViewController.newInstance()
                                    self?.present(loginViewController, animated: true, completion: {
                                        self?.showErrorMessage(message: message, type: .token)
                                    })
                                    LoadingView.finish()
                                } else {
                                    LoadingView.failed()
                                    self?.showErrorMessage(message: message, type: .token)
                                }

                                return
                            }
                        }

                        if let pageInfo = jsonData["pagination"] as? [String: Any], let nextID = pageInfo["next_min_id"] as? String {
                            self?.nextMediaID = nextID
                        }

                        if isRefresh {
                            self?.finishRefresh()
                        } else if (self?.extendView.beginLoading)! {
                            self?.finishExtend()
                        } else {
                            LoadingView.finish()
                        }

                        self?.updateMediaList(jsons: jsonData, isRefresh: isRefresh, isExpand: isExpand)
                    }
                }
            }) { [weak self] (error) in
                DispatchQueue.main.async {
                    if (self?.refreshView.beginLoading)! {
                        self?.finishRefresh()
                        self?.showErrorMessage(message: error.localizedDescription, type: .confirm)
                    } else {
                        LoadingView.failed()
                        self?.showErrorMessage(message: error.localizedDescription, type: .retry)
                    }
                }
            }
        }
    }

    // MARK: UI update

    private func finishRefresh() {
        UIView.animate(withDuration: 0.3, animations: {
            self.collectionView.contentInset.top = 0.0
        }, completion: { (completion) in
            self.refreshView.finish()
        })
    }

    private func finishExtend() {
        UIView.animate(withDuration: 0.3, animations: {
            self.collectionView.contentInset.bottom = 0.0
        }, completion: { (completion) in
            self.extendView.finish()
        })
    }


    private func updateMediaList(jsons: [String: Any], isRefresh: Bool, isExpand: Bool) {
        if let mediaArray = jsons["data"] as? [[String: Any]] {
            if isRefresh {
                medias.removeAll()
            }
            medias.append(contentsOf: mediaArray.map{ InstaMedia($0) })
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                if !isRefresh, !isExpand {
                    self.collectionView.alpha = 0.0
                    UIView.animate(withDuration: 0.3, animations: {
                        self.collectionView.alpha = 1.0
                    })
                }
            }
        }
    }

    private func showLogin() {
        let loginViewController = LoginViewController.newInstance()
        (loginViewController.topViewController as? LoginViewController)?.loginDelegate = self
        self.present(loginViewController, animated: true, completion: nil)
    }

    override func retry(type: AlertButtonType) {
        if type == .retry {
            self.loadTagMedias(tag: keyword, isRefresh: false, isExpand: false)
        }
    }

    // MARK: button action

    @objc override func logout() {
        let alert = UIAlertController(title: nil, message: "로그아웃 하시겠습니까?", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "취소", style: .default, handler: nil))

        alert.addAction(UIAlertAction(title: "로그아웃", style: .default, handler: { [weak self] action in
            DispatchQueue.main.async {
                self?.medias.removeAll()
                self?.extendView.alpha = 0.0
                self?.collectionView.reloadData()
                TokenManager.shared.clear()
                self?.showLogin()
            }
        }))

        self.present(alert, animated: true, completion: nil)
    }


}

extension HomeViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return medias.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeMediaCell", for: indexPath) as! HomeMediaCell
        cell.willDisplayContent(cellContent: medias[indexPath.row])
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let media = medias[indexPath.row]
        self.navigationController?.pushViewController(DetailViewController.newInstance(media: media), animated: true)
    }
}

extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let refreshTriggerRate = -scrollView.contentOffset.y / pullToRefreshTriggerOffset
        backgroundView.alpha = refreshTriggerRate - 0.4
        if !refreshView.beginLoading {
            refreshView.update(rate: refreshTriggerRate)
        }

        if nextMediaID != "" {
            let scrollOffsetHeight: CGFloat = scrollView.contentSize.height - scrollView.contentOffset.y
            if scrollOffsetHeight < self.view.bounds.height - (scrollToExtendTriggerOffset / 2.0), !extendView.beginLoading {
                extendView.update(rate: -(scrollOffsetHeight - self.view.bounds.height) / scrollToExtendTriggerOffset - 0.5)
            }
        }

    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if refreshView.canRefresh {
            loadTagMedias(tag: keyword, isRefresh: true, isExpand: false)
            scrollView.contentInset.top = pullToRefreshTriggerOffset
            refreshView.begin()
        }

        if nextMediaID != "" {
            if scrollView.contentSize.height - scrollView.contentOffset.y < self.view.bounds.height - scrollToExtendTriggerOffset {
                extendView.begin()
                scrollView.contentInset.bottom = 60.0
                self.loadTagMedias(tag: keyword, isRefresh: false, isExpand: true)
            }
        }
    }
}

extension HomeViewController: LoginDelegate {
    func finishLogin() {
        loadMainData()
    }

}
