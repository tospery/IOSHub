//
//  ProviderType+GithubBaseAPI.swift
//  IOSHub
//
//  Created by 杨建祥 on 2022/11/27.
//

import Foundation
import Moya
import RxSwift
import RxCocoa
import HiIOS

extension ProviderType {

    /// 用户登录
    func login(token: String) -> Single<User> {
        networking.requestObject(
            MultiTarget.init(
                GithubBaseAPI.login(token: token)
            ),
            type: User.self
        )
    }
    
    /// 用户信息
    /// - API: https://docs.github.com/en/rest/reference/users#get-a-user
    /// - Demo: https://api.github.com/users/ReactiveX
    func user(username: String) -> Single<User> {
        networking.requestObject(
            MultiTarget.init(
                GithubBaseAPI.user(username: username)
            ),
            type: User.self
        )
    }
    
    /// 仓库详情
    /// - API: https://docs.github.com/rest/reference/repos#get-a-repository
    /// - Demo: https://api.github.com/repos/ReactiveX/RxSwift
    func repo(username: String, reponame: String) -> Single<Repo> {
        networking.requestObject(
            MultiTarget.init(
                GithubBaseAPI.repo(username: username, reponame: reponame)
            ),
            type: Repo.self
        )
    }
    
    /// README
    /// - API: https://docs.github.com/en/rest/reference/repos#get-a-repository-readme
    /// - Demo: https://api.github.com/repos/ReactiveX/RxSwift/readme
    func readme(username: String, reponame: String, ref: String?) -> Single<Readme> {
        networking.requestObject(
            MultiTarget.init(
                GithubBaseAPI.readme(username: username, reponame: reponame, ref: ref)
            ),
            type: Readme.self
        )
    }
    
    /// 用户关注的仓库列表
    /// - API: https://docs.github.com/en/rest/reference/activity#list-repositories-starred-by-a-user
    /// - Demo: https://api.github.com/users/tospery/starred?page=1&per_page=20
    func starredRepos(username: String, page: Int) -> Single<[Repo]> {
        networking.requestArray(
            MultiTarget.init(
                GithubBaseAPI.starredRepos(username: username, page: page)
            ),
            type: Repo.self
        )
    }
    
    /// 搜索仓库
    /// - API: https://docs.github.com/v3/search
    /// - Demo: https://api.github.com/search/repositories?q=rxswift
    func searchRepos(keyword: String, sort: Sort = .stars, order: Order = .desc, page: Int) -> Single<[Repo]> {
        networking.requestList(
            MultiTarget.init(
                GithubBaseAPI.searchRepos(keyword: keyword, sort: sort, order: order, page: page)
            ),
            type: Repo.self
        ).map { $0.items }
    }
    
    /// 搜索开发者
    /// - API: https://docs.github.com/v3/search
    /// - Demo: https://api.github.com/search/users?q=rxswift
    func searchUsers(keyword: String, sort: Sort = .stars, order: Order = .desc, page: Int) -> Single<[User]> {
        networking.requestList(
            MultiTarget.init(
                GithubBaseAPI.searchUsers(keyword: keyword, sort: sort, order: order, page: page)
            ),
            type: User.self
        ).map { $0.items }
    }
    
    func follow(username: String) -> Single<Void> {
        networking.requestRaw(
            MultiTarget.init(
                GithubBaseAPI.follow(username: username)
            )
        ).mapTo(())
    }

    func unFollow(username: String) -> Single<Void> {
        networking.requestRaw(
            MultiTarget.init(
                GithubBaseAPI.unFollow(username: username)
            )
        ).mapTo(())
    }
    
    func checkFollow(username: String) -> Single<Bool> {
        networking.requestRaw(
            MultiTarget.init(
                GithubBaseAPI.checkFollow(username: username)
            )
        )
        .filterSuccessfulStatusCodes()
        .mapTo(true)
        .catchAndReturn(false)
    }

    /// 提交问题
    /// - API: https://docs.github.com/en/rest/reference/issues#create-an-issue
    /// - Demo: https://api.github.com/repos/tospery/IOSHub/issues
    func feedback(title: String, body: String) -> Single<Issue> {
        networking.requestObject(
            MultiTarget.init(
                GithubBaseAPI.feedback(title: title, body: body)
            ),
            type: Issue.self
        )
    }
    
    /// 用户事件
    func userEvents(username: String, page: Int) -> Single<[Event]> {
        networking.requestArray(
            MultiTarget.init(
                GithubBaseAPI.userEvents(username: username, page: page)
            ),
            type: Event.self
        )
    }
    
}
