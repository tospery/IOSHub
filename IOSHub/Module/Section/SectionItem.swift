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
    case repoSummary(RepoSummaryItem)
    case repoDetails(RepoDetailsItem)
    case user(UserItem)
    case searchOptions(SearchOptionsItem)
    case searchKeywords(SearchKeywordsItem)
    case readmeContent(ReadmeContentItem)
    
    var identity: String {
        var string = ""
        switch self {
        case let .simple(item): string = item.description
        case let .appInfo(item): string = item.description
        case let .repoSummary(item): string = item.description
        case let .repoDetails(item): string = item.description
        case let .user(item): string = item.description
        case let .searchOptions(item): string = item.description
        case let .searchKeywords(item): string = item.description
        case let .readmeContent(item): string = item.description
        }
        return string // String.init(string.sorted())
    }

    static func == (lhs: SectionItem, rhs: SectionItem) -> Bool {
        let result = (lhs.identity == rhs.identity)
        if result == false {
            switch lhs {
            case .simple: log("item变化 -> simple")
            case .appInfo: log("item变化 -> appInfo")
            case .repoSummary: log("item变化 -> repoSummary")
            case .repoDetails: log("item变化 -> repoDetails")
            case .user: log("item变化 -> user")
            case .searchOptions: log("item变化 -> searchOptions")
            case .searchKeywords: log("item变化 -> searchKeywords")
            case .readmeContent: log("item变化 -> readmeContent")
            }
        }
        return result
    }
    
}
