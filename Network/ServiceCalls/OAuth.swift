//
//  File.swift
//  
//
//  Created by Luke Allen on 12/16/19.
//

import Foundation
import Combine

class OAuthRequest: NetworkRequest {
    init(grant_type: String = "password", client_id: String, client_secret: String, email: String, password: String) {
        self.grant_type = grant_type
        self.client_id = client_id
        self.client_secret = client_secret
        self.email = email
        self.password = password
    }
    let grant_type: String
    let client_id: String
    let client_secret: String
    let email: String
    let password: String
}

class OAuthRefreshRequest: NetworkRequest {
    init(grant_type: String = "refresh_token", client_id: String, client_secret: String, refresh_token: String) {
        self.grant_type = grant_type
        self.client_id = client_id
        self.client_secret = client_secret
        self.refresh_token = refresh_token
    }
    let grant_type: String
    let client_id: String
    let client_secret: String
    let refresh_token: String
}

class OAuthResponse: NetworkResponse {
    let access_token: String
    let token_type: String
    let expires_in: Int
    let refresh_token: String
    let created_at: Int
    
    init(access_token: String, tokenType: String, expires: Int, refresh: String, created: Int) {
        self.access_token = access_token
        self.token_type = tokenType
        self.expires_in = expires
        self.refresh_token = refresh
        self.created_at = created
    }
    
    static func fake() -> OAuthResponse {
        OAuthResponse(access_token: "fake", tokenType: "fake", expires: 999999999, refresh: "fake", created: Int(Date().timeIntervalSince1970))
    }
    
}

class OAuth {
    
    class func login(email: String, password: String, completion: @escaping (OAuthResponse?, Error?) -> ()) -> AnyCancellable? {
        if email.lowercased() == "luketimallen@gmail.com" && password.lowercased() == "testaccount" {
            //Test account for Apple testing
            let res = OAuthResponse.fake()
            processAuthResponse(res)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                completion(res, nil)
            }
            return nil
        }
        let req = OAuthRequest(grant_type: "password", client_id: TeslaAPI.clientID, client_secret: TeslaAPI.clientSecret, email: email, password: password)
        let svc = NetworkService<OAuthRequest, OAuthResponse>(endpoint: TeslaPath.token, request: req)
        return svc.send { response, httpStatus, error in
            processAuthResponse(response) { res in
                completion(res, error)
            }
        }
    }
    
    class func refresh() -> AnyCancellable? {
        guard let refresh_token = SecureData.refresh_token else { return nil }
        let req = OAuthRefreshRequest(client_id: TeslaAPI.clientID, client_secret: TeslaAPI.clientSecret, refresh_token: refresh_token)
        let svc = NetworkService<OAuthRefreshRequest, OAuthResponse>(endpoint: TeslaPath.token, request: req)
        return svc.send { response, httpStatus, error in
            processAuthResponse(response) { res in
                Debug.log("Token Refreshed")
            }
        }
    }
    
    class func processAuthResponse(_ response: OAuthResponse?, completion: ((OAuthResponse?) -> ())? = nil) {
        guard let response = response else {
            Debug.log()
            completion?(nil)
            return
        }
        KeychainWrapper.standard.set(response.access_token, forKey: SecureData.Keys.access_token)
        KeychainWrapper.standard.set(response.token_type, forKey: SecureData.Keys.token_type)
        KeychainWrapper.standard.set(response.expires_in, forKey: SecureData.Keys.expires_in)
        KeychainWrapper.standard.set(response.refresh_token, forKey: SecureData.Keys.refresh_token)
        KeychainWrapper.standard.set(response.created_at, forKey: SecureData.Keys.created_at)
        completion?(response)
    }
    
}
