//
//  GithubBaseAPI.swift
//  IOSHub
//
//  Created by 杨建祥 on 2022/11/27.
//

import Foundation
import Moya
import SwifterSwift_Hi
import HiIOS

enum GithubBaseAPI {
    case login(token: String)
    case user(username: String)
    case userRepos(username: String, page: Int)
    case starredRepos(username: String, page: Int)
}

extension GithubBaseAPI: TargetType {

    var baseURL: URL {
        return UIApplication.shared.baseApiUrl.url!
    }

    var path: String {
        switch self {
        case .login: return "/user"
        case let .user(username): return "/users/\(username)"
        case let .userRepos(username, _): return "/users/\(username)/repos"
        case let .starredRepos(username, _): return "/users/\(username)/starred"
        }
    }

    var method: Moya.Method {
        .get
    }

    var headers: [String: String]? {
        switch self {
        case let .login(token):
            return ["Authorization": "token \(token)"]
        default:
            if let token = AccessToken.current?.accessToken {
                return ["Authorization": "token \(token)"]
            }
            return nil
        }
    }

    var task: Task {
        var parameters = envParameters
        let encoding: ParameterEncoding = URLEncoding.default
        switch self {
        case .userRepos(_, let page),
             .starredRepos(_, let page):
            parameters += [
                Parameter.pageIndex: page,
                Parameter.pageSize: UIApplication.shared.pageSize
            ]
        default:
            break
        }
        return .requestParameters(parameters: parameters, encoding: encoding)
    }

    var validationType: ValidationType { .none }

    var sampleData: Data {
        Data.init()
    }

}
