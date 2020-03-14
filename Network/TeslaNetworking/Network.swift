//
//  Network.swift
//  TeslaApp
//
//  Created by Luke Allen on 8/16/19.
//  Copyright © 2019 Luke Allen. All rights reserved.
//

import SwiftUI
import Combine

struct TeslaPath {
    static let token = "/oauth/token"
    static let vehiclesList = "/api/1/vehicles"
    static let wake = "/api/1/vehicles/:id/wake_up"
    static let unlock = "/api/1/vehicles/:id/command/door_unlock"
}

class Network<Request: NetworkRequest, Response: NetworkResponse> {
    
    //https://owner-api.teslamotors.com
    
    let scheme: String = "https"
    let host: String = "owner-api.teslamotors.com"
    
    var baseUrlComponents: URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        return urlComponents
    }
    
    func submitRequest(_ action: String, httpMethod: String = "GET", request: Request, completion:((Response) -> Void)?) {
        var urlComponents = baseUrlComponents
        urlComponents.path = action
        guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
        print(url.absoluteString)
        // Specify this request as being a POST method
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod
        // Make sure that we include headers specifying that our request's HTTP body
        // will be JSON encoded
        var headers = urlRequest.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        if let authHeader = CoreDataHelper.shared.profile.authToken {
            headers["Authorization"] = "Bearer \(authHeader)"
        }
        urlRequest.allHTTPHeaderFields = headers
        
        // Now let's encode our Post struct into JSON data...
        if httpMethod != "GET" {
            guard let data = try? JSONEncoder().encode(request) else {
                return
            }
            urlRequest.httpBody = data
        }
        
        // Create and run a URLSession data task with our JSON encoded POST request
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let p = session.dataTaskPublisher(for: urlRequest)
        let task = session.dataTask(with: urlRequest) { (responseData, response, responseError) in
            guard responseError == nil else {
                return
            }
            
            // APIs usually respond with the data you just sent in your POST request
            
            if let data = responseData, let utf8Representation = String(data: data, encoding: .utf8) {
                self.processResponse(data)
                print("response: ", utf8Representation)
            } else {
                print("no readable data received in response")
            }
        }
        task.resume()
    }
    
    func processResponse(_ data: Data) {
        let decoder = JSONDecoder()
        guard let jsonDict = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: AnyObject] else { return }
        if let token = jsonDict["access_token"] as? String {
            CoreDataHelper.shared.profile.authToken = token
        }
        if let expiration = jsonDict["expires_in"] as? Int {
            let date = Date().addingTimeInterval(TimeInterval(expiration))
            CoreDataHelper.shared.profile.tokenExpiration = date
        }
        if let refreshToken = jsonDict["refresh_token"] as? String {
            CoreDataHelper.shared.profile.refreshToken = refreshToken
        }
        CoreDataHelper.shared.save()
    }
    
}
