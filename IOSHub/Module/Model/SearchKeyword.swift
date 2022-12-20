//
//  History.swift
//  IOSHub
//
//  Created by 杨建祥 on 2022/12/12.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator
import Rswift
import HiIOS
import ReusableKit_Hi
import ObjectMapper_Hi

struct SearchKeyword: Subjective, Eventable {
    
    enum Event {
    }
    
    var id = 0
    var name: String?
    
    init() { }

    init?(map: Map) { }

    mutating func mapping(map: Map) {
        id          <- map["id"]
        name        <- map["name"]
    }
    
}
