//
//  TrendingViewReactor.swift
//  IOSHub
//
//  Created by 杨建祥 on 2020/11/28.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator
import Rswift
import Parchment
import HiIOS

class TrendingViewReactor: ScrollViewReactor, ReactorKit.Reactor {

    enum Action {
        case load
    }

    enum Mutation {
        case setLoading(Bool)
        case setRefreshing(Bool)
        case setLoadingMore(Bool)
        case setTitle(String?)
        case setError(Error?)
        case setUser(User?)
        case setConfiguration(Configuration)
        case setPages([Page])
        case initial([HiSection])
        case append([HiSection])
    }

    struct State {
        var isLoading = false
        var isRefreshing = false
        var isLoadingMore = false
        var noMoreData = false
        var error: Error?
        var title: String?
        var user: User?
        var configuration = Configuration.current!
        var pages = [Page].init()
        var total = [HiSection].init()
        var added = [HiSection].init()
        var sections = [Section].init()
    }

    var initialState = State()

    required init(_ provider: HiIOS.ProviderType, _ parameters: [String: Any]?) {
        super.init(provider, parameters)
        self.initialState = State(
            title: self.title ?? R.string.localizable.trending(),
            pages: Page.cachedArray() ?? []
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .load:
            return Observable.concat([
                .just(.initial([])),
                .just(.setError(nil)),
                .just(.setLoading(true)),
//                self.provider.categories()
//                    .asObservable()
//                    .map(Mutation.setCategories),
                .just(.setLoading(false))
            ]).catch({
                .concat([
                    .just(.initial([])),
                    .just(.setError($0)),
                    .just(.setLoading(false))
                ])
            })
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
        case let .setRefreshing(isRefreshing):
            newState.isRefreshing = isRefreshing
        case let .setLoadingMore(isLoadingMore):
            newState.isLoadingMore = isLoadingMore
        case let .setTitle(title):
            newState.title = title
        case let .setError(error):
            newState.error = error
        case let .setUser(user):
            newState.user = user
        case let .setConfiguration(configuration):
            newState.configuration = configuration
        case let .setPages(pages):
            newState.pages = pages
        case let .initial(data):
            newState.total = data
            return self.reduceSections(newState, additional: false)
        case let .append(added):
            newState.added = added
            return self.reduceSections(newState, additional: true)
        }
        return newState
    }
    
    func transform(action: Observable<Action>) -> Observable<Action> {
        action
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        .merge(
            mutation,
            Subjection.for(User.self)
                .distinctUntilChanged()
                .asObservable()
                .map(Mutation.setUser),
            Subjection.for(Configuration.self)
                .distinctUntilChanged()
                .filterNil()
                .asObservable()
                .map(Mutation.setConfiguration)
        )
    }
    
    func transform(state: Observable<State>) -> Observable<State> {
        state
    }

    func reduceSections(_ state: State, additional: Bool) -> State {
//        var newState = state
//        var noMore = false
//        if additional {
//            var models = [ModelType].init()
//            if let old = newState.total.first, old.header == nil {
//                models.append(contentsOf: old.models)
//            }
//            if let new = newState.added.first, new.header == nil {
//                models.append(contentsOf: new.models)
//                noMore = new.models.count < self.pageSize
//            }
//            newState.total = models.count == 0 ? [] : [(header: nil, models: models)]
//        } else {
//            noMore = newState.total.first?.models.count ?? 0 < self.pageSize
//        }
//        newState.noMoreData = noMore
//        newState.sections = (newState.total.count == 0 ? [] : newState.total.map {
//            .sectionItems(header: $0.header?.description ?? "", items: $0.models.map {
//                if let value = ($0 as? BaseModel)?.data as? SectionItemValue {
//                    switch value {
//                    case .logout:
//                        return .logout(.init($0))
//                    case .ranking:
//                        return .ranking(.init($0))
//                    }
//                }
//                if let user = $0 as? User {
//                    switch user.cellType {
//                    case .userInfo:
//                        return .userInfo(.init($0))
//                    default:
//                        break
//                    }
//                }
//                if $0 is Article {
//                    return .project(.init($0))
//                }
//                return .simple(.init($0))
//            })
//        })
//        return newState
        return state
    }
    
}
