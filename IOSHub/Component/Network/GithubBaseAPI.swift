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

//follow -> put
//https://api.github.com/user/following/karpathy
//unfollow -> delete
//https://api.github.com/user/following/karpathy

//case followUser(username: String)
//case unfollowUser(username: String)

enum GithubBaseAPI {
    case login(token: String)
    case user(username: String)
    case repo(username: String, reponame: String)
    case readme(username: String, reponame: String, ref: String?)
    case userRepos(username: String, page: Int)
    case starredRepos(username: String, page: Int)
    case searchRepos(keyword: String, sort: Sort, order: Order, page: Int)
    case searchUsers(keyword: String, sort: Sort, order: Order, page: Int)
    case doFollow(username: String)
    case unFollow(username: String)
}

extension GithubBaseAPI: TargetType {

    var baseURL: URL {
        return UIApplication.shared.baseApiUrl.url!
    }

    var path: String {
        switch self {
        case .login: return "/user"
        case let .user(username): return "/users/\(username)"
        case let .repo(username, reponame): return "/repos/\(username)/\(reponame)"
        case let .readme(username, reponame, _): return "/repos/\(username)/\(reponame)/readme"
        case let .userRepos(username, _): return "/users/\(username)/repos"
        case let .starredRepos(username, _): return "/users/\(username)/starred"
        case .searchRepos: return "/search/repositories"
        case .searchUsers: return "/search/users"
        case .doFollow(let username),
                .unFollow(let username):
            return "/user/following/\(username)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .doFollow: return .put
        case .unFollow: return .delete
        default: return .get
        }
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
        case let .readme(_, _, ref):
            parameters[Parameter.ref] = ref
        case .searchRepos(let keyword, let sort, let order, let page),
             .searchUsers(let keyword, let sort, let order, let page):
            parameters[Parameter.searchKey] = keyword
            parameters[Parameter.sort] = sort.rawValue
            parameters[Parameter.order] = order.rawValue
            parameters[Parameter.pageIndex] = page
            parameters[Parameter.pageSize] = UIApplication.shared.pageSize
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
