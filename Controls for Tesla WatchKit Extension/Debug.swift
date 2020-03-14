//
//  Debug.swift
//  Key for Tesla WatchKit Extension
//
//  Created by Luke Allen on 2/6/20.
//  Copyright © 2020 Luke Allen. All rights reserved.
//

import Foundation

class Debug {
    
    static func log(_ fmt : String = "", line: Int = #line, file: String = #file, function: String = #function) {
        #if targetEnvironment(simulator)
        let filesplit = file.components(separatedBy: "/")
        guard filesplit.count > 1 else {
            print(fmt)
            return
        }
        let filename = filesplit[filesplit.count - 1]
        print("\(fmt) [" + function + "] [\(filename) Line \(line)]")
        #endif
    }
    
}
