//
//  DataType.swift
//  IOSHub
//
//  Created by liaoya on 2022/7/21.
//

import Foundation
import HiIOS

enum TabBarKey {
    case trending
    case event
    case stars
    case personal
}

enum DisplayMode: Int, Codable {
    case none = 0
    case list
    
    var stringValue: String {
        switch self {
        case .none: return "none"
        case .list: return "list"
        }
    }
}

enum Sort: String, Codable {
    case stars
    case forks
    case updated
    case issues  = "help-wanted-issues"
}

enum Order: String, Codable {
    case asc
    case desc
}

enum Platform {
    case github
    case umeng
    case weixin
    
    var appId: String {
        switch self {
        case .github: return "a9c077fbcecd8ecf53ae"
        case .umeng: return "6093ae3653b6726499ec3983"
        case .weixin: return UIApplication.shared.urlScheme(name: "weixin") ?? ""
        }
    }
    
    var appKey: String {
        switch self {
        case .github: return "ba4678daaa04dd61cfbcf17c106d103f40c6fad9"
        case .umeng: return "6093ae3653b6726499ec3983"
        case .weixin: return "f7f6a7c1cbe503c497151e076c0a4b4d"
        }
    }

//    var appSecret: String {
//        ""
//    }
    
    var appLink: String {
        switch self {
        case .weixin: return "https://tospery.com/swhub/"
        default: return ""
        }
    }

}

enum Since: String, Codable {
    case daily
    case weekly
    case montly
    
    static let name = R.string.localizable.since()
    static let allValues = [daily, weekly, montly]
    
//    var paramValue: String {
//        switch self {
//        case .daily: return R.string.localizable.daily()
//        case .weekly: return R.string.localizable.weekly()
//        case .montly: return R.string.localizable.montly()
//        }
//    }
}

enum CellId: Int {
    case space          = 0, button
    case setting        = 10, about, feedback
    case company        = 20, location, email, blog, nickname, bio
    case author         = 30, weibo, shcemes, score, share
    case language       = 40, issues, pullrequests, branches, readme
    case cache          = 50, theme, local
    
    var title: String? {
        switch self {
        case .issues: return R.string.localizable.issues()
        case .pullrequests: return R.string.localizable.pullRequests()
        case .branches: return R.string.localizable.branches()
        case .readme: return R.string.localizable.readme().uppercased()
        case .cache: return R.string.localizable.clearCache()
        case .theme: return R.string.localizable.colorTheme()
        case .local: return R.string.localizable.languageEnvironment()
        default: return nil
        }
    }
    
    var icon: String? {
        switch self {
        // user
        case .company: return R.image.ic_user_company.name
        case .location: return R.image.ic_user_location.name
        case .email: return R.image.ic_user_email.name
        case .blog: return R.image.ic_user_blog.name
        // repo
        case .language: return R.image.ic_repo_language.name
        case .issues: return R.image.ic_repo_issues.name
        case .pullrequests: return R.image.ic_repo_pullrequests.name
        case .branches: return R.image.ic_repo_branches.name
        case .readme: return R.image.ic_repo_readme.name
        default: return nil
        }
    }
}

enum IHAlertAction: AlertActionType, Equatable {
    case destructive
    case `default`
    case cancel
    case input
    case onlyPublic
    case withPrivate
    case exit
    
    init?(string: String) {
        switch string {
        case IHAlertAction.cancel.title: self = IHAlertAction.cancel
        case IHAlertAction.exit.title: self = IHAlertAction.exit
        default: return nil
        }
    }

    var title: String? {
        switch self {
        case .destructive:  return R.string.localizable.sure()
        case .default:  return R.string.localizable.oK()
        case .cancel: return R.string.localizable.cancel()
        case .onlyPublic: return R.string.localizable.loginPrivilegeOnlyPublic()
        case .withPrivate: return R.string.localizable.loginPrivilegeWithPrivate()
        case .exit: return R.string.localizable.exit()
        default: return nil
        }
    }

    var style: UIAlertAction.Style {
        switch self {
        case .cancel:  return .cancel
        case .destructive, .exit:  return .destructive
        default: return .default
        }
    }

    static func == (lhs: IHAlertAction, rhs: IHAlertAction) -> Bool {
        switch (lhs, rhs) {
        case (.destructive, .destructive),
            (.default, .default),
            (.cancel, .cancel),
            (.input, .input),
            (.onlyPublic, .onlyPublic),
            (.withPrivate, .withPrivate),
            (.exit, .exit):
            return true
        default:
            return false
        }
    }
}

struct Author {
    static let username = "tospery"
    static let reponame = "IOSHub"
}

struct Metric {
    static let listAvatarSize = CGSize.init(40.f)
    static let detailAvatarSize = CGSize.init(60.f)
    
    struct Repo {
        static let maxLines             = 5
    }
    
    struct Personal {
        static let parallaxTopHeight    = 244.0
        static let parallaxAllHeight    = 290.0
    }
}
