//
//  InstagramURL.swift
//  Songstagram
//
//  Created by Song on 2018. 7. 19..
//  Copyright © 2018년 Song. All rights reserved.
//

import Foundation

struct INSTAGRAM_URL {
    static let BASEURL = "https://api.instagram.com/v1/"
    static let AUTHURL = "https://api.instagram.com/oauth/authorize/"
    static let AUTHURL_FORMAT = "%@?client_id=%@&redirect_uri=%@&response_type=token&scope=%@&DEBUG=True"
    static let APIURL  = "https://api.instagram.com/v1/users/"
    static let CLIENT_ID  = "f206f9716a3840d88ebbe9cffd748d26"
    static let CLIENTSERCRET = "94765f799e5a42448ad722d9f5bd0f6f"
    static let REDIRECT_URL = "https://zonmat.io"
    static let SCOPE = "basic+public_content+follower_list+comments+relationships+likes"
    static let TOKEN_KEY = "#access_token"
    static var ACCESS_TOKEN = ""
}
