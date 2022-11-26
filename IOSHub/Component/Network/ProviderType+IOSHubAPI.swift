//
//  ProviderType+Networking.swift
//  IOSHub
//
//  Created by 杨建祥 on 2020/11/28.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator
import Rswift
import HiIOS
import Moya

extension HiIOS.ProviderType {
    
    /// 登录
    /// - API: https://api.ioshub.com/login
    /// - Demo: https://m.github.com/users/login
    func login(username: String, password: String) -> Single<User> {
        networking.requestObject(
            MultiTarget.init(
                IOSHubAPI.login(username: username, password: password)
            ),
            type: User.self
        )
    }

}
