//
//  RepoListViewController.swift
//  IOSHub
//
//  Created by 杨建祥 on 2022/12/3.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator
import Rswift
import ReusableKit_Hi
import ObjectMapper_Hi
import RxDataSources
import RxGesture
import HiIOS

class RepoListViewController: NormalViewController {
    
    required init(_ navigator: NavigatorProtocol, _ reactor: BaseViewReactor) {
        super.init(navigator, reactor)
//        self.shouldRefresh = reactor.parameters.bool(for: Parameter.shouldRefresh) ?? true
//        self.shouldLoadMore = reactor.parameters.bool(for: Parameter.shouldLoadMore) ?? true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollView.frame = self.view.bounds
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        var size = super.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath)
        if size.width > deviceWidth {
            size.width = deviceWidth
        }
        return size
    }
    
    override func handleTotal(total: [HiSection]) {
        guard let displayMode = (self.reactor as? RepoListViewReactor)?.displayMode else { return }
        guard displayMode == .list else { return }
        guard let repos = total.first?.models as? [Repo], repos.isNotEmpty else { return }
        Repo.storeArray(repos, page: displayMode.stringValue)
        log("趋势缓存：(\(self.reactor?.host ?? ""), \(self.reactor?.path ?? "")), \(displayMode.stringValue)")
    }

}
