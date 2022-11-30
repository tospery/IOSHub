//
//  ProviderType+TrendingAPI.swift
//  IOSHub
//
//  Created by 杨建祥 on 2022/11/30.
//

import Foundation
import Moya
import RxSwift
import RxCocoa
import HiIOS

extension ProviderType {
    
    // MARK: - TrendingAPI
    /// 仓库推荐: https://gtrend.yapie.me/repositories
    func repositories(language: Language? = nil, since: Since? = nil) -> Single<[Repo]> {
        return networking.requestArray(
            MultiTarget.init(
                TrendingAPI.repositories(language: language, since: since)
            ),
            type: Repo.self
        )
    }
    
    /// 开发者推荐: https://gtrend.yapie.me/developers
    func developers(language: Language? = nil, since: Since? = nil) -> Single<[User]> {
        networking.requestArray(
            MultiTarget.init(
                TrendingAPI.developers(language: language, since: since)
            ),
            type: User.self
        )
    }
    
    /// 编程语言
    func languages() -> Single<[Language]> {
        networking.requestArray(
            MultiTarget.init(
                TrendingAPI.languages
            ),
            type: Language.self
        )
    }
    
}
