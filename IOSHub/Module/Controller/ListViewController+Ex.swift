//
//  ListViewController+Ex.swift
//  IOSHub
//
//  Created by liaoya on 2021/6/29.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator
import Rswift
import HiIOS

extension ListViewController {
    
    func toAction(reactor: ListViewReactor) {
        self.rx.load.map { Reactor.Action.load }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        self.rx.refresh.map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        self.rx.loadMore.map { Reactor.Action.loadMore }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
    }
    
    // swiftlint:disable function_body_length
    func fromState(reactor: ListViewReactor) {
        reactor.state.map { $0.title }
            .distinctUntilChanged()
            .bind(to: self.rx.title)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: self.rx.loading)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.isRefreshing }
            .distinctUntilChanged()
            .bind(to: self.rx.refreshing)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.isLoadingMore }
            .distinctUntilChanged()
            .bind(to: self.rx.loadingMore)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.isActivating }
            .distinctUntilChanged()
            .bind(to: self.rx.activating)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.noMoreData }
            .distinctUntilChanged()
            .bind(to: self.rx.noMoreData)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.urlString }
            .distinctUntilChanged()
            .filterNil()
            .subscribeNext(weak: self, type(of: self).handleForward)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.dependency }
            .distinctUntilChanged { HiIOS.compareAny($0, $1) }
            .skip(1)
            .subscribeNext(weak: self, type(of: self).handleDependency)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.user }
            .distinctUntilChanged()
            .skip(1)
            .subscribeNext(weak: self, type(of: self).handleUser)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.error }
            .distinctUntilChanged({ $0?.asHiError == $1?.asHiError })
            .bind(to: self.rx.error)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.sections }
            .distinctUntilChanged()
            .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
    }
    // swiftlint:enable function_body_length
    
    // MARK: - handle
    func handleUser(user: User?) {
        guard let host = self.reactor?.host else { return }
        let selector = Selector.init(
            "handle/user/when/\(host)/\(self.reactor?.path ?? ""):".method
        )
        if self.responds(to: selector) {
            log("执行\(selector)", module: .runtime)
            self.perform(selector, with: user)
            return
        }
        log("缺少\(selector)", module: .runtime)
    }
    
    func handleDependency(dependency: Any?) {
        guard let host = self.reactor?.host else { return }
        let selector = Selector.init(
            "handle/dependency/when/\(host)/\(self.reactor?.path ?? ""):".method
        )
        if self.responds(to: selector) {
            self.perform(selector, with: dependency)
            return
        }
        log("缺少\(selector)", module: .runtime)
    }
    
    func handleForward(urlString: String) {
        self.navigator.forward(urlString)
    }
    
    // MARK: - tap
    func tapCell(sectionItem: SectionItem) {
        guard let host = self.reactor?.host else { return }
        let selector = Selector.init(
            "tap/cell/when/\(host)/\(self.reactor?.path ?? ""):".method
        )
        if self.responds(to: selector) {
            self.perform(selector, with: sectionItem)
            return
        }
        log("缺少\(selector)", module: .runtime)
    }

}
