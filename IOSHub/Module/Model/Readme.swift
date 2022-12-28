//
//  Readme.swift
//  IOSHub
//
//  Created by 杨建祥 on 2022/12/28.
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

struct Readme: Subjective, Eventable {
    
    enum Event {
    }
    
    var id = ""
    var links: Link?
    var content: String?
    var downloadUrl: String?
    var encoding: String?
    var gitUrl: String?
    var htmlUrl: String?
    var name: String?
    var path: String?
    var size: Int?
    var type: String?
    var url: String?
    var height = 0.f
    
    var sha: String { self.id }
    
    init() { }

    init?(map: Map) { }

    mutating func mapping(map: Map) {
        id              <- map["sha"]
        links           <- map["_links"]
        content         <- map["content"]
        downloadUrl     <- map["download_url"]
        encoding        <- map["encoding"]
        gitUrl          <- map["git_url"]
        htmlUrl         <- map["html_url"]
        name            <- map["name"]
        path            <- map["path"]
        size            <- map["size"]
        type            <- map["type"]
        url             <- map["url"]
        height          <- map["height"]
    }
    
}
