//
//  MyRouter+Page.swift
//  IOSHub
//
//  Created by 杨建祥 on 2020/11/28.
//

import Foundation
import HiIOS
import URLNavigator

extension Router {
    
    public func page(_ provider: HiIOS.ProviderType, _ navigator: NavigatorProtocol) {
        let normalFactory: ViewControllerFactory = { url, values, context in
            guard let parameters = self.parameters(url, values, context) else { return nil }
            return ListViewController(navigator, ListViewReactor.init(provider, parameters))
        }
        navigator.register(self.urlPattern(host: .about), normalFactory)
    }
    
}
