//
//  BaseUser.swift
//  IOSHub
//
//  Created by 杨建祥 on 2022/11/29.
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

struct BaseUser: Subjective, Eventable {

    enum Event {
    }

    var id = 0
    var username: String?
    var href: String?
    var avatar: String?

    init() { }

    init?(map: Map) { }

    mutating func mapping(map: Map) {
        id          <- map["id"]
        username    <- map["username"]
        href        <- map["href"]
        avatar      <- map["avatar"]
    }

}
