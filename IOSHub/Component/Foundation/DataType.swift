//
//  DataType.swift
//  IOSHub
//
//  Created by liaoya on 2022/7/21.
//

import Foundation
import HiIOS

enum TabBarKey {
    case dashboard
    case event
    case stars
    case personal
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
