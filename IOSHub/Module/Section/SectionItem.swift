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
    case submit(SubmitItem)
    case appInfo(AppInfoItem)
    case milestone(MilestoneItem)
    case userTrending(UserTrendingItem)
    case userDetail(UserDetailItem)
    case repoTrending(RepoTrendingItem)
    case repoDetail(RepoDetailItem)
    case searchOptions(SearchOptionsItem)
    case searchKeywords(SearchKeywordsItem)
    case readmeContent(ReadmeContentItem)
    case feedbackNote(FeedbackNoteItem)
    case feedbackInput(FeedbackInputItem)
    
    var identity: String {
        var string = ""
        switch self {
        case let .simple(item): string = item.description
        case let .submit(item): string = item.description
        case let .appInfo(item): string = item.description
        case let .milestone(item): string = item.description
        case let .userTrending(item): string = item.description
        case let .userDetail(item): string = item.description
        case let .repoTrending(item): string = item.description
        case let .repoDetail(item): string = item.description
        case let .searchOptions(item): string = item.description
        case let .searchKeywords(item): string = item.description
        case let .readmeContent(item): string = item.description
        case let .feedbackNote(item): string = item.description
        case let .feedbackInput(item): string = item.description
        }
        return string // String.init(string.sorted())
    }

    // swiftlint:disable cyclomatic_complexity
    static func == (lhs: SectionItem, rhs: SectionItem) -> Bool {
        let result = (lhs.identity == rhs.identity)
        if result == false {
            switch lhs {
            case .simple: log("item变化 -> simple")
            case .submit: log("item变化 -> submit")
            case .appInfo: log("item变化 -> appInfo")
            case .milestone: log("item变化 -> milestone")
            case .userTrending: log("item变化 -> userTrending")
            case .userDetail: log("item变化 -> userDetail")
            case .repoTrending: log("item变化 -> repoTrending")
            case .repoDetail: log("item变化 -> repoDetail")
            case .searchOptions: log("item变化 -> searchOptions")
            case .searchKeywords: log("item变化 -> searchKeywords")
            case .readmeContent: log("item变化 -> readmeContent")
            case .feedbackNote: log("item变化 -> feedbackNote")
            case .feedbackInput: log("item变化 -> feedbackInput")
            }
        }
        return result
    }
    // swiftlint:enable cyclomatic_complexity
    
}
