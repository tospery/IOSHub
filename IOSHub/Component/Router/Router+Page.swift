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
        navigator.register(self.urlPattern(host: .setting)) { url, values, context in
            SettingViewController(navigator, SettingViewReactor(provider, self.parameters(url, values, context)))
        }
        navigator.register(self.urlPattern(host: .about)) { url, values, context in
            AboutViewController(navigator, AboutViewReactor(provider, self.parameters(url, values, context)))
        }
        navigator.register(self.urlPattern(host: .profile)) { url, values, context in
            ProfileViewController(navigator, ProfileViewReactor(provider, self.parameters(url, values, context)))
        }
        navigator.register(self.urlPattern(host: .repo, path: .list)) { url, values, context in
            RepoListViewController(navigator, RepoListViewReactor(provider, self.parameters(url, values, context)))
        }
        navigator.register(self.urlPattern(host: .user, path: .list)) { url, values, context in
            UserListViewController(navigator, UserListViewReactor(provider, self.parameters(url, values, context)))
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
        navigator.register(self.urlPattern(host: .user, placeholder: "<username>")) { url, values, context in
            UserViewController(navigator, UserViewReactor(provider, self.parameters(url, values, context)))
        }
        navigator.register(self.urlPattern(host: .repo, placeholder: "<username>/<reponame>")) { url, values, context in
            RepoViewController(navigator, RepoViewReactor(provider, self.parameters(url, values, context)))
        }
        navigator.register(self.urlPattern(host: .feedback)) { url, values, context in
            FeedbackViewController(navigator, FeedbackViewReactor(provider, self.parameters(url, values, context)))
        }
    }
    
}
