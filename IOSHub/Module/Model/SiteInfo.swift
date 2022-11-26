//
//  SiteInfo.swift
//  IOSHub
//
//  Created by 杨建祥 on 2020/11/28.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator
import Rswift
import HiIOS
import ReusableKit_Hi
import ObjectMapper_Hi

struct SiteInfo: ModelType, Identifiable, Subjective {
    
    var id = ""
    var title = ""
    var slogan = ""
    var domain = ""
    var description = ""
    
    init() {
    }

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        id              <- map["id"]
        title           <- map["title"]
        slogan          <- map["slogan"]
        domain          <- map["domain"]
        description     <- map["description"]
    }
    
}
