//
//  NetworkService.swift
//  Key for Tesla WatchKit Extension
//
//  Created by Luke Allen on 2/6/20.
//  Copyright © 2020 Luke Allen. All rights reserved.
//

import Foundation
import Combine

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}

enum HTTPError: LocalizedError {
    case statusCode
}

class NetworkService<Request: NetworkRequest, Response: NetworkResponse> {
    var endpoint: String
    let session = URLSession.shared
    let method: HttpMethod
    let decoder = JSONDecoder()
    var request: Request?
    var cancellable: AnyCancellable?
    
    init(endpoint: String, method: HttpMethod = .post, request: Request? = nil) {
        self.endpoint = endpoint
        self.request = request
        self.method = method
    }
    
    var baseUrlComponents: URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = TeslaAPI.scheme
        urlComponents.host = TeslaAPI.host
        urlComponents.path = endpoint
        return urlComponents
    }
    
    var url: URL? {
        baseUrlComponents.url
    }
    
    var urlRequest: URLRequest? {
        guard let url = url else {
            return nil
        }
        var req = URLRequest(url: url)
        var headers = req.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        if let authHeader = SecureData.access_token {
            headers["Authorization"] = "Bearer \(authHeader)"
        }
        req.allHTTPHeaderFields = headers
        req.httpMethod = method.rawValue
        if method == .post {
            if let codable = request {
                guard let data = try? JSONEncoder().encode(codable) else {
                    return nil
                }
                req.httpBody = data
            }
        }
        return req
    }
    
    func send(_ completion: @escaping (Response?, Int?, Error?) -> Void) -> AnyCancellable? {
        guard let req = urlRequest else {
            completion(nil, nil, nil)
            return nil
        }
        
        guard SecureData.access_token != "fake" else {
            let resp: Response? = Response.fake() as? Response
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                completion(resp, 200, nil)
            }
            return nil
        }
        
        Debug.log("REQUEST:")
        if let data = req.httpBody {
            Debug.log(String(data: data, encoding: .utf8) ?? "Can't decode request data")
        }
        Debug.log(req.url?.absoluteString ?? "Null URL")
        
        self.cancellable = session.dataTaskPublisher(for: req)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw HTTPError.statusCode
                }
                return output.data
            }
            .decode(type: Response.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
            .sink(receiveCompletion: { comp in
                switch comp {
                case .finished:
                    Debug.log("Finished")
                    break
                case .failure(let error):
                    Debug.log(error.localizedDescription)
                    completion(nil, nil, error)
                }
            }, receiveValue: { response in
                Debug.log()
                completion(response, nil, nil)
            })
        return self.cancellable
    }
    
}
