//
//  ProviderType+Networking.swift
//  IOSHub
//
//  Created by 杨建祥 on 2020/11/28.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator
import Rswift
import HiIOS
import Moya

let networking = Networking(
    provider: MoyaProvider<MultiTarget>(
        endpointClosure: Networking.endpointClosure,
        requestClosure: Networking.requestClosure,
        stubClosure: Networking.stubClosure,
        callbackQueue: Networking.callbackQueue,
        session: Networking.session,
        plugins: Networking.plugins,
        trackInflights: Networking.trackInflights
    )
)

extension HiIOS.ProviderType {
    
    // MARK: - SwiftPTAPI
    /// SwiftPT网站信息：https://api.swiftpt.com/api/site/info.json
    func siteInfo() -> Single<SiteInfo> {
        networking.requestObject(
            MultiTarget.init(SwiftPTAPI.siteInfo),
            type: SiteInfo.self
        )
    }
    
}
