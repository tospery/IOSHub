//
//  String+Ex.swift
//  IOSHub
//
//  Created by liaoya on 2021/6/28.
//

import Foundation

extension String {
    
    var method: String {
        self.replacingOccurrences(of: "/", with: " ").camelCased
    }
    
}
