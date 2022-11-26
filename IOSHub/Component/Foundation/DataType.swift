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

enum PieceId: Int {
    case nickname = 1
    case bio, company, location, blog
}

enum SimpleId: Int {
    case space      = 0, button
    case setting    = 100, about, feedback
    case company    = 200, location, email, blog, nickname, bio
    case author     = 300, weibo, shcemes, rating, share
}

enum IHAlertAction: AlertActionType, Equatable {
    case destructive
    case `default`
    case cancel
    case input
    case onlyPublic
    case withPrivate

    var title: String? {
        switch self {
        case .destructive:  return R.string.localizable.sure()
        case .default:  return R.string.localizable.oK()
        case .cancel: return R.string.localizable.cancel()
        case .onlyPublic: return R.string.localizable.loginPrivilegeOnlyPublic()
        case .withPrivate: return R.string.localizable.loginPrivilegeWithPrivate()
        default: return nil
        }
    }

    var style: UIAlertAction.Style {
        switch self {
        case .cancel:  return .cancel
        case .destructive:  return .destructive
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
            (.withPrivate, .withPrivate):
            return true
        default:
            return false
        }
    }
}
