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
    case feedback(title: String, body: String)
    case user(username: String)
    case repo(username: String, reponame: String)
    case readme(username: String, reponame: String, ref: String?)
    case userRepos(username: String, page: Int)
    case starredRepos(username: String, page: Int)
    case searchRepos(keyword: String, sort: Sort, order: Order, page: Int)
    case searchUsers(keyword: String, sort: Sort, order: Order, page: Int)
    case follow(username: String)
    case unFollow(username: String)
    case checkFollow(username: String)
    case userEvents(username: String, page: Int)
}

extension GithubBaseAPI: TargetType {

    var baseURL: URL {
        return UIApplication.shared.baseApiUrl.url!
    }

    var path: String {
        switch self {
        case .login: return "/user"
        case .feedback: return "/repos/\(Author.username)/\(Author.reponame)/issues"
        case let .user(username): return "/users/\(username)"
        case let .repo(username, reponame): return "/repos/\(username)/\(reponame)"
        case let .readme(username, reponame, _): return "/repos/\(username)/\(reponame)/readme"
        case let .userRepos(username, _): return "/users/\(username)/repos"
        case let .starredRepos(username, _): return "/users/\(username)/starred"
        case .searchRepos: return "/search/repositories"
        case .searchUsers: return "/search/users"
        case .follow(let username),
                .unFollow(let username),
                .checkFollow(let username):
            return "/user/following/\(username)"
//        case .events: return "/events"
//        case .repositoryEvents(let owner, let repo, _): return "/repos/\(owner)/\(repo)/events"
//        case .userReceivedEvents(let username, _): return "/users/\(username)/received_events"
//        case .userPerformedEvents(let username, _): return "/users/\(username)/events"
//        case .organizationEvents(let username, _): return "/orgs/\(username)/events"
        case let .userEvents(username, _): return "/users/\(username)/received_events"
        }
    }

    var method: Moya.Method {
        switch self {
        case .feedback: return .post
        case .follow: return .put
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
        var encoding: ParameterEncoding = URLEncoding.default
        switch self {
        case let .feedback(title, body):
            parameters[Parameter.title] = title
            parameters[Parameter.body] = body
            encoding = JSONEncoding.default
        case .userRepos(_, let page),
             .starredRepos(_, let page),
             .userEvents(_, let page):
            parameters[Parameter.pageIndex] = page
            parameters[Parameter.pageSize] = UIApplication.shared.pageSize
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
