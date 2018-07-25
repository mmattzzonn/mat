//
//  TokenManager.swift
//  Songstagram
//
//  Created by Song on 2018. 7. 23..
//  Copyright © 2018년 Song. All rights reserved.
//

import Foundation

import UIKit
import Security


class TokenManager {

    static let shared = TokenManager()

    private init() {
        
    }

    func saveToken(_ token: String) {

        if let dataFromString = token.data(using: .utf8) {
            let keychainQuery = [kSecClass as String: kSecClassInternetPassword,
                                 kSecAttrServer as String: Bundle.main.bundleIdentifier!,
                                 kSecAttrAccount as String: "InstagramToken",
                                 kSecValueData as String: dataFromString] as [String : Any]
            SecItemDelete(keychainQuery as CFDictionary)
            let status: OSStatus = SecItemAdd(keychainQuery as CFDictionary, nil)

            if status != errSecSuccess {
                print("Error! \(status)")
            }
        }
    }


    func loadToken() -> String? {

        var dataTypeRef: AnyObject?
        var token: String?

        let keychainQuery = [kSecClass as String: kSecClassInternetPassword,
                             kSecAttrServer as String: Bundle.main.bundleIdentifier!,
                             kSecAttrAccount as String: "InstagramToken",
                             kSecReturnData as String: true,
                             kSecReturnAttributes as String: true,
                             kSecMatchLimit as String: kSecMatchLimitOne,] as [String : Any]

        let status: OSStatus = SecItemCopyMatching(keychainQuery as CFDictionary, &dataTypeRef)

        if (status == errSecSuccess) {
            if let existingItem = dataTypeRef as? [String : Any],
                let passwordData = existingItem[kSecValueData as String] as? Data,
                let password = String(data: passwordData, encoding: String.Encoding.utf8) {
                token = password
            }
        } else {
            print("Error! \(status)")
        }

        return token
    }

    func clear() {
        let keychainQuery = [kSecClass as String: kSecClassInternetPassword,
                             kSecAttrServer as String: Bundle.main.bundleIdentifier!,
                             kSecAttrAccount as String: "InstagramToken"] as [String : Any]
        SecItemDelete(keychainQuery as CFDictionary)
        let status: OSStatus = SecItemAdd(keychainQuery as CFDictionary, nil)

        if status != errSecSuccess {
            print("Error! \(status)")
        }
    }
}

