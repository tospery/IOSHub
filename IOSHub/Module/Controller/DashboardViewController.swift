//
//  DashboardViewController.swift
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
import ReusableKit_Hi
import ObjectMapper_Hi
import RxDataSources
import RxGesture
import MXParallaxHeader
import Parchment
import SnapKit
import HiIOS

class DashboardViewController: ScrollViewController, ReactorKit.View {
    
    lazy var paging: NavigationBarPagingViewController = {
        let paging = NavigationBarPagingViewController()
        paging.menuBackgroundColor = .clear
        paging.menuHorizontalAlignment = .center
        paging.borderOptions = .hidden
        paging.menuItemSize = .selfSizing(estimatedWidth: 100, height: navigationBarHeight)
        return paging
    }()
    
    required init(_ navigator: NavigatorProtocol, _ reactor: BaseViewReactor) {
        defer {
            self.reactor = reactor as? DashboardViewReactor
        }
        super.init(navigator, reactor)
        self.tabBarItem.title = reactor.title ?? (reactor as? DashboardViewReactor)?.currentState.title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationBar.removeAllLeftButtons()
//        self.navigationBar.addButtonToLeft(image: R.image.navbar_scan()?.template)
//            .rx.tap.subscribe(onNext: { [weak self] _ in
//                guard let `self` = self else { return }
//                self.scan()
//            }).disposed(by: self.disposeBag)
//        self.navigationBar.titleView = self.searchView
        
//        self.paging.dataSource = self.reactor
//        self.addChild(self.paging)
//        self.view.addSubview(self.paging.view)
//        self.paging.didMove(toParent: self)
//        self.paging.view.frame = self.contentFrame
//        self.navigationBar.theme.itemColor = themeService.attribute { $0.primaryColor }
        
        self.addChild(self.paging)
        self.view.addSubview(self.paging.view)
        // let tabBarHeight = self.tabBarController?.tabBar.height ?? 0
        self.paging.view.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(self.contentTop)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-tabBarHeight)
        }
        self.paging.didMove(toParent: self)
        self.paging.dataSource = self.reactor

        self.paging.collectionView.size = CGSize(width: self.view.width, height: navigationBarHeight)
        self.navigationBar.titleView = self.paging.collectionView

        // v1.0.0版本屏蔽该功能，完善功能后下个版本打开
//        self.navigationBar.addButtonToLeft(image: R.image.nav_menu()).rx.tap
//            .subscribeNext(weak: self, type(of: self).tapMenu)
//            .disposed(by: self.disposeBag)
//        self.navigationBar.addButtonToRight(image: R.image.nav_search()).rx.tap
//            .subscribeNext(weak: self, type(of: self).tapSearch)
//            .disposed(by: self.disposeBag)
//
//        themeService.rx
//            .bind({ $0.brightColor }, to: self.paging.view.rx.backgroundColor)
//            .bind({ $0.primaryColor }, to: [self.paging.rx.indicatorColor, self.paging.rx.selectedTextColor])
//            .bind({ $0.titleColor }, to: self.paging.rx.textColor)
//            .disposed(by: self.rx.disposeBag)
    }
    
    func bind(reactor: DashboardViewReactor) {
        super.bind(reactor: reactor)
        // action
        self.rx.load.map { Reactor.Action.load }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        // state
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: self.rx.loading)
            .disposed(by: self.disposeBag)
//        reactor.state.map { $0.categories }
//            .distinctUntilChanged()
//            .bind(to: self.rx.categories)
//            .disposed(by: self.disposeBag)
    }

}

class NavigationBarPagingView: PagingView {

    override func setupConstraints() {
        pageView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

}

class NavigationBarPagingViewController: PagingViewController {

    override func loadView() {
        view = NavigationBarPagingView(
            options: options,
            collectionView: collectionView,
            pageView: pageViewController.view
        )
    }

}
