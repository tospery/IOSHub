//
//  ListViewReactor+Ex.swift
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

extension ListViewReactor {
    
    // MARK: - actions
    func load() -> Observable<Mutation> {
        return Observable.concat([
            .just(.initial([])),
            .just(.setError(nil)),
            .just(.setLoading(true)),
            self.loadDependency(),
            self.loadData(self.pageStart)
                .map(Mutation.initial),
            .just(.setLoading(false)),
            self.loadExtra()
        ])
        .do(onCompleted: { [weak self] in
            guard let `self` = self else { return }
            self.pageIndex = self.pageStart
        })
        .catch({
            .concat([
                .just(.initial([])),
                .just(.setError($0)),
                .just(.setLoading(false))
            ])
        })
    }
    
    func refresh() -> Observable<Mutation> {
        return Observable.concat([
            .just(.setError(nil)),
            .just(.setRefreshing(true)),
            self.loadData(self.pageStart)
                .errorOnEmpty()
                .map(Mutation.initial),
            .just(.setRefreshing(false))
        ]).do(onCompleted: { [weak self] in
            guard let `self` = self else { return }
            self.pageIndex = self.pageStart
        }).catch({
            .concat([
                .just(.setError($0)),
                .just(.setRefreshing(false))
            ])
        })
    }
    
    func loadMore() -> Observable<Mutation> {
        return Observable.concat([
            .just(.setError(nil)),
            .just(.setLoadingMore(true)),
//            self.loadData(self.pageIndex + 1)
//                .errorOnEmpty()
//                .map(Mutation.append),
            .just(.setLoadingMore(false))
        ]).do(onCompleted: { [weak self] in
            guard let `self` = self else { return }
            self.pageIndex += 1
        }).catch({
            .concat([
                .just(.setError($0)),
                .just(.setLoadingMore(false))
            ])
        })
    }
    
    func activate(_ data: Any?) -> Observable<Mutation> {
        var activate: Observable<Mutation>!
        let selector = Selector.init(
            "activate/when/\(self.host)/\(self.path ?? ""):".method
        )
        if self.responds(to: selector) {
            activate = self.perform(selector, with: data).takeUnretainedValue() as? Observable<Mutation> ?? .empty()
        } else {
            log("缺少\(selector)", module: .runtime)
            // return .just(.setData(data))
            return .empty()
        }
        guard !self.currentState.isActivating else { return .empty() }
        return .concat([
            .just(.setError(nil)),
            .just(.setActivating(true)),
            activate,
            .just(.setActivating(false))
        ]).catch({
            .concat([
                .just(.setError($0)),
                .just(.setActivating(false))
            ])
        })
    }
    
    func reduceSections(_ state: State, additional: Bool) -> State {
        let selector = Selector.init(
            "reduce/sections/when/\(self.host)/\(self.path ?? "")::".method
        )
        if self.responds(to: selector) {
            return self.perform(
                selector, with: state, with: additional
            ).takeUnretainedValue() as? State ?? state
        }
        log("缺少\(selector)", module: .runtime)
        return state
    }
    
    // MARK: - dependency/data
    func loadDependency() -> Observable<Mutation> {
        let selector = Selector.init(
            "load/dependency/when/\(self.host)/\(self.path ?? "")".method
        )
        if self.responds(to: selector) {
            return self.perform(selector)
                .takeUnretainedValue() as? Observable<Mutation> ?? .empty()
        }
        log("不需要依赖项\(selector)", module: .runtime)
        return .empty()
    }
    
    func loadData(_ page: Int) -> Observable<[SectionData]> {
        let selector = Selector.init(
            "load/data/when/\(self.host)/\(self.path ?? ""):".method
        )
        if self.responds(to: selector) {
            return self.perform(selector, with: page)
                .takeUnretainedValue() as? Observable<[SectionData]> ?? .empty()
        }
        log("不需要加载项\(selector)", module: .runtime)
        return .empty()
    }
    
    func loadExtra() -> Observable<Mutation> {
        let selector = Selector.init(
            "load/extra/when/\(self.host)/\(self.path ?? "")".method
        )
        if self.responds(to: selector) {
            return self.perform(selector).takeUnretainedValue() as? Observable<Mutation> ?? .empty()
        }
        log("不需要额外项\(selector)", module: .runtime)
        return .empty()
    }
    
}

extension ListViewReactor.Action {
    
    static func isLoad(_ action: ListViewReactor.Action) -> Bool {
        if case .load = action {
            return true
        }
        return false
    }
    
}
