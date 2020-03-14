//
//  SecureData.swift
//  Key for Tesla WatchKit Extension
//
//  Created by Luke Allen on 2/6/20.
//  Copyright © 2020 Luke Allen. All rights reserved.
//

import Foundation

class SecureData {
    static var access_token: String? {
        get {
            KeychainWrapper.standard.string(forKey: Keys.access_token)
        }
        set {
            setNewValue(newValue, forKey: Keys.access_token)
        }
    }
    static var token_type: String? {
        get {
            KeychainWrapper.standard.string(forKey: Keys.token_type)
        }
        set {
            setNewValue(newValue, forKey: Keys.token_type)
        }
    }
    static var expires_in: Int? {
        get {
            KeychainWrapper.standard.integer(forKey: Keys.expires_in)
        }
        set {
            setNewValue(newValue, forKey: Keys.expires_in)
        }
    }
    static var refresh_token: String? {
        get {
            KeychainWrapper.standard.string(forKey: Keys.refresh_token)
        }
        set {
            setNewValue(newValue, forKey: Keys.refresh_token)
        }
    }
    static var created_at: Int? {
        get {
            KeychainWrapper.standard.integer(forKey: Keys.created_at)
        }
        set {
            setNewValue(newValue, forKey: Keys.created_at)
        }
    }
    static func clearKeychain() {
        KeychainWrapper.standard.removeAllKeys()
    }
    static func setNewValue(_ val: Any?, forKey key: String) {
        if let val = val as? Bool {
            KeychainWrapper.standard.set(val, forKey: key)
        } else if let val = val as? String {
            KeychainWrapper.standard.set(val, forKey: key)
        } else if let val = val as? Int {
            KeychainWrapper.standard.set(val, forKey: key)
        } else {
            KeychainWrapper.standard.removeObject(forKey: key)
        }
    }
}

extension SecureData {
    enum Keys {
        static let access_token = "access_token"
        static let token_type = "token_type"
        static let expires_in = "expires_in"
        static let refresh_token = "refresh_token"
        static let created_at = "created_at"
    }
}

extension SecureData {
    static var secondsInAWeek: Double {
        60.0 * 60.0 * 24.0 * 7.0
    }
    static var expiration: Int64 {
        Int64(created_at ?? 0) + Int64(expires_in ?? 0)
    }
    static var timeUntilExpire: Double {
        Double(expiration) - Date().timeIntervalSince1970
    }
    static var hasValidToken: Bool {
        Date().timeIntervalSince1970 < Double(expiration)
    }
    static var shouldRefresh: Bool {
        refresh_token != nil && timeUntilExpire < secondsInAWeek
    }
}
