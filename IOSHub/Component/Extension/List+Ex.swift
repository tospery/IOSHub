//
//  List+Ex.swift
//  IOSHub
//
//  Created by liaoya on 2021/6/28.
//

import Foundation
import HiIOS
import ReusableKit_Hi
import ObjectMapper_Hi

extension List: ListCompatible {
    public func hasNext(map: Map) -> Bool {
        var hasNext: Bool?
        hasNext   <- map["incomplete_results"]
        return !(hasNext ?? false)
    }
    
    public func count(map: Map) -> Int {
        var count: Int?
        count   <- map["total_count"]
        return count ?? 0
    }
    
    public func items<Item>(map: Map) -> [Item] where Item: ModelType {
        var items: [Item]?
        items    <- map["items"]
        return items ?? []
    }
}
