//
//  DetailViewController.swift
//  Songstagram
//
//  Created by Song on 2018. 7. 22..
//  Copyright © 2018년 Song. All rights reserved.
//

import UIKit
import Security
import MapKit

class DetailViewController: ViewController {

    var instaMedia: InstaMedia?
    var locationData: GoogleLocation?
    var reviews = [GoogleReview]()

    @IBOutlet var locationNameLabel: UILabel!
    @IBOutlet var locationAddressLabel: UILabel!

    @IBOutlet var tableHeaderView: DetailTableHeaderView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var topConstraint: NSLayoutConstraint!
    @IBOutlet var mapView: MKMapView!

    class func newInstance(media: InstaMedia) -> DetailViewController {
        let storyboard = UIStoryboard(name: "Detail", bundle: nil)
        guard let instance = storyboard.instantiateViewController(withIdentifier: "detailViewController") as? DetailViewController else {
            fatalError()
        }
        instance.instaMedia = media
        return instance
    }

    // MARK: lifcycle

    override func viewDidLoad() {
        super.viewDidLoad()

        locationNameLabel.text = instaMedia?.location?.name
        loadLocationData()

        self.tableHeaderView.frame = CGRect(x: 0.0, y: 0.0,
                                            width: self.view.frame.width,
                                            height: self.view.frame.width + mapView.frame.height)


        if let images = instaMedia?.images {
            tableHeaderView.updateHeaderView(images: images)
        }

        topConstraint.constant = -UIApplication.shared.statusBarFrame.height
        self.view.layoutIfNeeded()
        updateMapInfo()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }

    // MARK: api task

    private func loadLocationData() {

        if let data = instaMedia, let locationName = data.location?.name, let lat = data.location?.lat, let lng = data.location?.lng,
            let url = URL(string: EndPoint.location(name: locationName.urlEncoding(), lat: "\(lat)", lng: "\(lng)").urlString) {
            LoadingView.begin(target: self.view)

            APIManager.requestURL(url: url, onSuccess: { [weak self] (data) in
                if let jsonString = String.init(data: data, encoding: String.Encoding.utf8) {
                    guard let jsonData = try! JSONSerialization.jsonObject(with: jsonString.data(using: String.Encoding.utf8)!, options: .allowFragments) as? [String: Any] else {
                        return
                    }

                    DispatchQueue.main.async {
                        if let locationArray = jsonData["candidates"] as? [[String: Any]], let data = locationArray.first {
                            self?.updateLocationInfo(data: GoogleLocation(dict: data))
                        } else {
                            LoadingView.finish()
                        }
                    }
                }
            }) { [weak self] (error) in
                DispatchQueue.main.async {
                    LoadingView.failed()
                    self?.showErrorMessage(message: error.localizedDescription, type: .retry)
                }
            }
        }
    }

    private func loadReviewData() {

        if let data = locationData, let locationID = data.identifier,
            let url = URL(string: EndPoint.review(location: locationID).urlString) {
            APIManager.requestURL(url: url, onSuccess: { [weak self] (data) in
                if let jsonData = data.convertJSON(),
                    let result = jsonData["result"] as? [String: Any],
                    let reviewDicts = result["reviews"] as? [[String: Any]] {
                    self?.reviews.append(contentsOf: reviewDicts.map{ GoogleReview(dict: $0) })
                }

                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    LoadingView.finish()
                }

            }) { [weak self] (error) in
                DispatchQueue.main.async {
                    LoadingView.failed()
                    self?.showErrorMessage(message: error.localizedDescription, type: .retry)
                }
            }
        }
    }

    // MARK: UI update

    private func updateLocationInfo(data: GoogleLocation) {
        locationData = data
        locationAddressLabel.text = locationData?.address

        loadReviewData()
    }

    override func retry(type: AlertButtonType) {
        if locationData == nil {
            self.loadLocationData()
        } else {
            LoadingView.begin(target: self.view)
            self.loadReviewData()
        }
    }

    
    private func updateMapInfo() {
        if let lat = instaMedia?.location?.lat, let lng = instaMedia?.location?.lng {
            let center = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(lat, lng)
            mapView.setRegion(region, animated: true)
            mapView.addAnnotation(annotation)
        }
    }

    // MARK: button action

    @IBAction func respondsToBack() {
        self.navigationController?.popViewController(animated: true)
    }

}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if reviews.count == 0 {
            return 1
        }
        return reviews.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if reviews.count > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailReviewCell", for: indexPath) as! DetailReviewCell
            cell.willDisplayContent(cellContent: reviews[indexPath.row])
            return cell
        }
        return tableView.dequeueReusableCell(withIdentifier: "EmptyReviewCell")!
    }
}

extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
