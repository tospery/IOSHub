//
//  TrendingViewReactor+Ex.swift
//  IOSHub
//
//  Created by 杨建祥 on 2022/12/2.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator
import Rswift
import Parchment
import HiIOS

extension TrendingViewReactor: PagingViewControllerDataSource {
    
    func numberOfViewControllers(
        in pagingViewController: PagingViewController
    ) -> Int {
        self.currentState.pages.count
    }

    func pagingViewController(
        _ pagingViewController: PagingViewController,
        viewControllerAt index: Int
    ) -> UIViewController {
        let id = self.currentState.pages[index].id
        switch id {
        case 1:
            return AppDependency.shared.navigator.viewController(
                for: Router.shared.urlString(
                    host: .repo,
                    path: .list,
                    parameters: [
                        Parameter.hidesNavigationBar: true.string
                    ]
                )
            )!
        default:
            return AppDependency.shared.navigator.viewController(
                for: Router.shared.urlString(
                    host: .user,
                    path: .list,
                    parameters: [
                        Parameter.hidesNavigationBar: true.string
                    ]
                )
            )!
        }
    }

    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        PagingIndexItem(index: index, title: self.currentState.pages[index].name ?? "")
    }
}
    
    
