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
import Ink
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
    var heights = [CGFloat].init()
    
    var sha: String { self.id }
    
    var html: String? {
        guard let content = self.content else { return nil }
        guard let data = Data.init(base64Encoded: content, options: .ignoreUnknownCharacters) else { return nil }
        guard let markdown = String.init(data: data, encoding: .utf8) else { return nil }
        let parser = MarkdownParser()
        let html = parser.html(from: markdown)
        return html
    }
    
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
        heights         <- map["heights"]
    }
    
}
