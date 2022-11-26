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
    
}

