//
//  File.swift
//  
//
//  Created by Luke Allen on 12/16/19.
//

import Foundation

struct OAuthRequest: NetworkRequest {
    let grant_type: String
    let client_id: String
    let client_secret: String
    let email: String
    let password: String
}

struct OAuthResponse: NetworkResponse {
    let access_token: String
    let token_type: String
    let expires_in: Int
    let refresh_token: String
    let created_at: Int
}

class OAuth {
    
    class func login(email: String, password: String, completion: @escaping (OAuthResponse) -> ()) {
        let req = OAuthRequest(grant_type: "password", client_id: TeslaAPI.clientID, client_secret: TeslaAPI.clientSecret, email: email, password: password)
        let svc = Network<OAuthRequest, OAuthResponse>()
        svc.submitRequest(TeslaPath.token,httpMethod: "POST", request: req) { (response) in
            completion(response)
        }
    }
    
}
