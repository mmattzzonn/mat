//
//  LoginViewController.swift
//  Songstagram
//
//  Created by Song on 2018. 7. 19..
//  Copyright © 2018년 Song. All rights reserved.
//

import UIKit
import WebKit

protocol LoginDelegate: class {
    func finishLogin()
}

class LoginViewController: ViewController {

    weak var loginDelegate: LoginDelegate?
    @IBOutlet var webView: WKWebView!

    class func newInstance() -> UINavigationController {
        let storyboard = UIStoryboard(name: "LoginViewController", bundle: nil)

        guard let instance = storyboard.instantiateViewController(withIdentifier: "loginViewController") as? LoginViewController else {
            fatalError()
        }

        let navigationController = UINavigationController(navigationBarClass: NavigationBar.self, toolbarClass: nil)
        navigationController.viewControllers = [instance]
        return navigationController
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LoadingView.begin(target: self.view)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "로그인"
        
        let authURL = String(format: INSTAGRAM_URL.AUTHURL_FORMAT,
                             arguments: [INSTAGRAM_URL.AUTHURL,
                                         INSTAGRAM_URL.CLIENT_ID,
                                         INSTAGRAM_URL.REDIRECT_URL,
                                         INSTAGRAM_URL.SCOPE ])

        let urlRequest =  URLRequest.init(url: URL.init(string: authURL)!)

        webView.load(urlRequest)
        webView.navigationDelegate = self

        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { (records) in
            for record in records {
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }

}

extension LoginViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        if let hasToken = webView.url?.absoluteString.contains(INSTAGRAM_URL.TOKEN_KEY), hasToken == true {
            if let token = webView.url?.absoluteString.split(separator: "=").last {
                TokenManager.shared.saveToken(String(token))
                self.dismiss(animated: true, completion: {
                    self.loginDelegate?.finishLogin()
                })
            }
        }
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping ((WKNavigationActionPolicy) -> Void)) {

        LoadingView.finish()

        if (navigationAction.navigationType == .linkActivated){
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}
