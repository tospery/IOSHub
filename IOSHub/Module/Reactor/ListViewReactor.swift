//
//  ListViewReactor.swift
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

class ListViewReactor: CollectionViewReactor, ReactorKit.Reactor {

    enum Action {
        case load
        case refresh
        case loadMore
        case activate(Any?)
        case reload
        case forward(String)
    }

    enum Mutation {
        case setLoading(Bool)
        case setRefreshing(Bool)
        case setLoadingMore(Bool)
        case setActivating(Bool)
        case setTitle(String?)
        case setError(Error?)
        case setUser(User?)
        case setPreference(Preference)
        case setURLString(String?)
        case setDependency(Any?)
        case setExtra(Any?)
        case initial([SectionData])
        case append([SectionData])
    }

    struct State {
        var isLoading = false
        var isRefreshing = false
        var isLoadingMore = false
        var isActivating = false
        var noMoreData = false
        var error: Error?
        var title: String?
        var user: User?
        var preference = Preference.current!
        var urlString: String?
        var dependency: Any?
        var extra: Any?
        var data = [SectionData].init()
        var additions = [SectionData].init()
        var sections = [Section].init()
    }

    let username: String!
    var initialState = State()

    required init(_ provider: HiIOS.ProviderType, _ parameters: [String: Any]?) {
        self.username = parameters?.string(for: Parameter.username)
        super.init(provider, parameters)
        self.initialState = State(
            title: self.title
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .load:
            return self.load()
        case .refresh:
            return self.refresh()
        case .loadMore:
            return self.loadMore()
        case let .activate(data):
            return self.activate(data)
        case .reload:
            return .empty()
//            return .concat([
//                .just(.initial([])),
//                self.loadModels(self.pageStart)
//                    .map(Mutation.initial)
//            ])
        case let .forward(urlString):
            return .concat([
                .just(.setURLString(nil)),
                .just(.setURLString(urlString))
            ])
        }
    }
    
    // swiftlint:disable cyclomatic_complexity
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
        case let .setRefreshing(isRefreshing):
            newState.isRefreshing = isRefreshing
        case let .setLoadingMore(isLoadingMore):
            newState.isLoadingMore = isLoadingMore
        case let .setActivating(isActivating):
            newState.isActivating = isActivating
        case let .setTitle(title):
            newState.title = title
        case let .setError(error):
            newState.error = error
        case let .setUser(user):
            newState.user = user
        case let .setPreference(preference):
            newState.preference = preference
        case let .setURLString(urlString):
            newState.urlString = urlString
        case let .setDependency(dependency):
            newState.dependency = dependency
        case let .setExtra(extra):
            newState.extra = extra
        case let .initial(data):
            newState.data = data
            return self.reduceSections(newState, additional: false)
        case let .append(additions):
            newState.additions = additions
            return self.reduceSections(newState, additional: true)
        }
        return newState
    }
    // swiftlint:enable cyclomatic_complexity
    
    func transform(action: Observable<Action>) -> Observable<Action> {
        action
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        return .merge(
            mutation,
            Subjection.for(User.self)
                .distinctUntilChanged()
                .asObservable()
                .map(Mutation.setUser),
            Subjection.for(Preference.self)
                .distinctUntilChanged()
                .filterNil()
                .asObservable()
                .map(Mutation.setPreference)
        )
    }
    
    func transform(state: Observable<State>) -> Observable<State> {
        state
    }

}
