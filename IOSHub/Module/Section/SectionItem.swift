//
//  SectionItem.swift
//  IOSHub
//
//  Created by 杨建祥 on 2022/10/3.
//

import Foundation
import RxDataSources
import ReusableKit_Hi
import ObjectMapper_Hi
import HiIOS

enum SectionItem: IdentifiableType, Equatable {
    case simple(SimpleItem)
    case appInfo(AppInfoItem)
    case repo(RepoItem)
    case user(UserItem)
    case searchType(SearchTypeItem)

    var identity: String {
        var string = ""
        switch self {
        case let .simple(item): string = item.description
        case let .appInfo(item): string = item.description
        case let .repo(item): string = item.description
        case let .user(item): string = item.description
        case let .searchType(item): string = item.description
        }
        return string // String.init(string.sorted())
    }

    static func == (lhs: SectionItem, rhs: SectionItem) -> Bool {
        let result = (lhs.identity == rhs.identity)
        if result == false {
            log("item变化")
        }
        return result
    }
    
}
