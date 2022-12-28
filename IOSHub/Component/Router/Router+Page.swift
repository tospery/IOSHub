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
//        let normalFactory: ViewControllerFactory = { url, values, context in
//            guard let parameters = self.parameters(url, values, context) else { return nil }
//            return NormalViewController(navigator, NormalViewReactor.init(provider, parameters))
//        }
//        navigator.register(self.urlPattern(host: .about), normalFactory)
        navigator.register(self.urlPattern(host: .trending)) { url, values, context in
            TrendingViewController(navigator, TrendingViewReactor(provider, self.parameters(url, values, context)))
        }
        navigator.register(self.urlPattern(host: .event)) { url, values, context in
            EventViewController(navigator, EventViewReactor(provider, self.parameters(url, values, context)))
        }
        navigator.register(self.urlPattern(host: .stars)) { url, values, context in
            StarsViewController(navigator, StarsViewReactor(provider, self.parameters(url, values, context)))
        }
        navigator.register(self.urlPattern(host: .personal)) { url, values, context in
            PersonalViewController(navigator, PersonalViewReactor(provider, self.parameters(url, values, context)))
        }
        navigator.register(self.urlPattern(host: .about)) { url, values, context in
            AboutViewController(navigator, AboutViewReactor(provider, self.parameters(url, values, context)))
        }
        navigator.register(self.urlPattern(host: .profile)) { url, values, context in
            ProfileViewController(navigator, ProfileViewReactor(provider, self.parameters(url, values, context)))
        }
        navigator.register(self.urlPattern(host: .repos)) { url, values, context in
            ReposViewController(navigator, ReposViewReactor(provider, self.parameters(url, values, context)))
        }
        navigator.register(self.urlPattern(host: .users)) { url, values, context in
            UsersViewController(navigator, UsersViewReactor(provider, self.parameters(url, values, context)))
        }
        navigator.register(self.urlPattern(host: .search, path: .history)) { url, values, context in
            SearchHistoryViewController(
                navigator,
                SearchHistoryViewReactor(provider, self.parameters(url, values, context))
            )
        }
        navigator.register(self.urlPattern(host: .search)) { url, values, context in
            SearchViewController(navigator, SearchViewReactor(provider, self.parameters(url, values, context)))
        }
        navigator.register(self.urlPattern(host: .repo, placeholder: "<username>/<reponame>")) { url, values, context in
            RepoViewController(navigator, RepoViewReactor(provider, self.parameters(url, values, context)))
        }
    }
    
}
