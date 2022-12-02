//
//  DashboardViewReactor+Ex.swift
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

extension DashboardViewReactor: PagingViewControllerDataSource {
    
    func numberOfViewControllers(
        in pagingViewController: PagingViewController
    ) -> Int {
        self.currentState.categories.count
    }

    func pagingViewController(
        _ pagingViewController: PagingViewController,
        viewControllerAt index: Int
    ) -> UIViewController {
//        let category = self.currentState.categories[index]
//        let viewController = AppDependency.shared.navigator.viewController(
//            for: Router.shared.urlString(
//                host: .article,
//                path: .list,
//                parameters: [
//                    Parameter.hidesNavigationBar: true.string,
//                    Parameter.categoryId: category.id.string
//                ]
//            )
//        )
//        return viewController!
        let vc = UIViewController.init()
        vc.view.backgroundColor = .random
        return vc
    }

    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        let category = self.currentState.categories[index]
        return PagingIndexItem(index: index, title: category.name ?? "")
    }
}
    
    
