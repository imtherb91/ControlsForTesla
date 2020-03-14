//
//  File.swift
//  
//
//  Created by Luke Allen on 12/16/19.
//

import Foundation

protocol NetworkResponse: Codable {
    associatedtype ObjectType = Self
    static func fake() -> ObjectType
}
