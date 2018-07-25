//
//  ViewController.swift
//  Songstagram
//
//  Created by Song on 2018. 7. 24..
//  Copyright © 2018년 Song. All rights reserved.
//

import UIKit

enum AlertButtonType: String {
    case retry = "재시도"
    case token = "로그인"
    case confirm = "확인"
}

enum NavigationButtonType {
    case back, close, logout
}

class ViewController: UIViewController {

    func showErrorMessage(message: String, type: AlertButtonType) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: type.rawValue, style: .default, handler: { [weak self] action in
            self?.retry(type: type)
        }))
        self.present(alert, animated: true, completion: nil)
    }

    func retry(type: AlertButtonType) {

    }

    func addLeftBarButtonItem(buttonType: NavigationButtonType) {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 44.0, height: 44.0))

        if buttonType == .close {
            button.setBackgroundImage(#imageLiteral(resourceName: "navigationClose"), for: .normal)
            button.addTarget(self, action: #selector(close), for: .touchUpInside)
        } else if buttonType == .back {
            button.setBackgroundImage(#imageLiteral(resourceName: "navigationBack"), for: .normal)
            button.addTarget(self, action: #selector(back), for: .touchUpInside)
        }

        let barButton = UIBarButtonItem(customView: button)
        barButton.style = .plain
        self.navigationItem.leftBarButtonItem = barButton
    }

    func addLogoutButtonItem() {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 44.0, height: 44.0))

        button.setBackgroundImage(#imageLiteral(resourceName: "logout"), for: .normal)
        button.addTarget(self, action: #selector(logout), for: .touchUpInside)

        let barButton = UIBarButtonItem(customView: button)
        barButton.style = .plain
        self.navigationItem.rightBarButtonItem = barButton
    }


    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func logout() {
    }


}
