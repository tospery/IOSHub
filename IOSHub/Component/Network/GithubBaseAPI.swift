//
//  GithubBaseAPI.swift
//  IOSHub
//
//  Created by 杨建祥 on 2022/11/27.
//

import Foundation
import Moya
import HiIOS

enum GithubBaseAPI {
    case login(token: String)
    case user(username: String)
}

extension GithubBaseAPI: TargetType {

    var baseURL: URL {
        return UIApplication.shared.baseApiUrl.url!
    }

    var path: String {
        switch self {
        case .login: return "/user"
        case let .user(username): return "/users/\(username)"
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
        let parameters = envParameters
        let encoding: ParameterEncoding = URLEncoding.default
//        switch self {
//        case let .feedback(title, body):
//            parameters["title"] = title
//            parameters["body"] = body
//            encoding = JSONEncoding.default
//        case let .modify(key, value):
//            parameters[key] = value
//            encoding = JSONEncoding.default
//        case .issues(_, _, let state, let page),
//             .pulls(_, _, let state, let page):
//            parameters["state"] = state.rawValue
//            parameters["page"] = page
//            parameters["per_page"] = UIApplication.shared.pageSize
//        case let .readme(_, _, ref):
//            parameters["ref"] = ref
//        case .searchRepos(let keyword, let sort, let order, let page),
//             .searchUsers(let keyword, let sort, let order, let page):
//            parameters["q"] = keyword
//            parameters["sort"] = sort.rawValue
//            parameters["order"] = order.rawValue
//            parameters["page"] = page
//            parameters["per_page"] = UIApplication.shared.pageSize
//        case .branches(_, _, let page),
//             .watchers(_, _, let page),
//             .stargazers(_, _, let page),
//             .forks(_, _, let page),
//             .userRepos(_, let page),
//             .starredRepos(_, let page),
//             .userFollowers(_, let page):
//            parameters["page"] = page
//            parameters["per_page"] = UIApplication.shared.pageSize
//        default:
//            return .requestPlain
//        }
        return .requestParameters(parameters: parameters, encoding: encoding)
    }

    var validationType: ValidationType { .none }

    var sampleData: Data {
        Data.init()
    }

}
