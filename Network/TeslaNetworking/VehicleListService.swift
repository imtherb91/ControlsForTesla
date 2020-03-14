//
//  File.swift
//  
//
//  Created by Luke Allen on 12/16/19.
//

import Foundation
import Combine

class VehicleListService {
    
    private let session: URLSession
    private let decoder: JSONDecoder
    private var cancellable: AnyCancellable?
    
    init(session: URLSession = .shared, decoder: JSONDecoder = .init()) {
        self.session = session
        self.decoder = decoder
    }
    
    func getList(_ completion: @escaping (VehiclesListResponse) -> ()) {
        guard let url = URL(string: TeslaAPI.baseUrl + TeslaPath.vehiclesList) else {
            preconditionFailure("Unable to create URL")
        }
        var urlRequest = URLRequest(url: url)
        var headers = urlRequest.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        if let authHeader = CoreDataHelper.shared.profile.authToken {
            headers["Authorization"] = "Bearer \(authHeader)"
        }
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpMethod = "GET"
        print(urlRequest.url ?? "No URL")
        print(CoreDataHelper.shared.profile.authToken ?? "No Auth token")
        self.cancellable = session.dataTaskPublisher(for: urlRequest)
            .map { $0.data }
            .decode(type: VehiclesListResponse.self, decoder: decoder)
            .eraseToAnyPublisher()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            }, receiveValue: { (response) in
                print(response)
            })
    }
}
