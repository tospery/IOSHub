//
//  NormalViewReactor.swift
//  IOSHub
//
//  Created by 杨建祥 on 2022/10/3.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator
import Rswift
import HiIOS

// swiftlint:disable type_body_length
class NormalViewReactor: HiIOS.CollectionViewReactor, ReactorKit.Reactor {

    enum Action {
        case load
        case refresh
        case loadMore
        case reload(Any?)
        // case erase
        case activate(Any?)
        case target(String)
        // case follow
    }

    enum Mutation {
        case setLoading(Bool)
        case setRefreshing(Bool)
        case setLoadingMore(Bool)
        case setActivating(Bool)
        case setFollowed(Bool?)
        case setTitle(String?)
        // case setKeywords([String])
        case setError(Error?)
        case setUser(User?)
        case setRepo(Repo?)
        case setReadme(Readme?)
        case setDataset(Dataset?)
        case setConfiguration(Configuration)
        case setTarget(String?)
        case initial([SectionData])
        case append([SectionData])
    }

    struct State {
        var isLoading = false
        var isRefreshing = false
        var isLoadingMore = false
        var isActivating = false
        var isFollowed: Bool?
        var noMoreData = false
        var error: Error?
        var title: String?
        // var keywords = [String].init()
        var user = User.current
        var repo: Repo?
        var readme: Readme?
        var dataset: Dataset?
        var configuration = Configuration.current!
        var target: String?
        var originals = [SectionData].init()
        var additions = [SectionData].init()
        var sections = [Section].init()
    }

    struct Dataset {
        var isFollowed: Bool?
        var user: User?
        var repo: Repo?
        var readme: Readme?
        
//        init(
//            repo: Repo? = nil,
//            readme: Readme? = nil
//        ) {
//            self.repo = repo
//            self.readme = readme
//        }
    }
    
    let username: String!
    let reponame: String!
    var initialState = State()

    required init(_ provider: HiIOS.ProviderType, _ parameters: [String: Any]?) {
        self.username = parameters?.string(for: Parameter.username)
        self.reponame = parameters?.string(for: Parameter.reponame)
        super.init(provider, parameters)
        self.pageStart = 0
        self.pageIndex = self.pageStart
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
        case let .reload(data):
            return self.reload(data)
//        case .follow:
//            return self.follow()
        case let .activate(data):
            return self.activate(data)
        case let .target(target):
            return .concat([
                .just(.setTarget(nil)),
                .just(.setTarget(target))
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
        case let .setFollowed(isFollowed):
            newState.isFollowed = isFollowed
        case let .setTitle(title):
            newState.title = title
        case let .setError(error):
            newState.error = error
        case let .setUser(user):
            newState.user = user
        case let .setRepo(repo):
            newState.repo = repo
        case let .setReadme(readme):
            newState.readme = readme
        case let .setDataset(dataset):
            newState.dataset = dataset
        case let .setConfiguration(configuration):
            newState.configuration = configuration
        case let .setTarget(target):
            newState.target = target
        case let .initial(data):
            newState.originals = data
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

    // MARK: - actions
    func load() -> Observable<Mutation> {
        .concat([
            .just(.initial([])),
            .just(.setError(nil)),
            .just(.setLoading(true)),
            self.loadDependency(),
            self.loadData(self.pageStart)
                .map(Mutation.initial),
            .just(.setLoading(false)),
            self.loadExtra()
        ]).catch({
            .concat([
                .just(.initial([])),
                .just(.setError($0)),
                .just(.setLoading(false))
            ])
        })
    }
    
    func refresh() -> Observable<Mutation> {
        .concat([
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
        .concat([
            .just(.setError(nil)),
            .just(.setLoadingMore(true)),
            self.loadData(self.pageIndex + 1)
                .errorOnEmpty()
                .map(Mutation.append),
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
        guard !self.currentState.isActivating else { return .empty() }
        return .concat([
            .just(.setError(nil)),
            .just(.setActivating(true)),
            self.business(data),
            .just(.setActivating(false))
        ]).catch({
            .concat([
                .just(.setError($0)),
                .just(.setActivating(false))
            ])
        })
    }
    
    func reload(_ data: Any?) -> Observable<Mutation> {
        self.load()
    }
    
//    func erase() -> Observable<Mutation> {
//        .concat([
//            self.reload()
//        ]).catch({
//            .concat([
//                .just(.initial([])),
//                .just(.setError($0)),
//                .just(.setLoading(false))
//            ])
//        })
//    }
    
    func business(_ data: Any?) -> Observable<Mutation> {
        .empty()
    }
    
    func silent(_ data: Any?) -> Observable<Mutation> {
        .empty()
    }
    
//    func follow() -> Observable<Mutation> {
//        .empty()
//    }
    
    func reduceSections(_ state: State, additional: Bool) -> State {
        var newState = state
        var noMore = false
        if additional {
            if newState.originals.isEmpty {
                newState.originals = newState.additions
                noMore = (newState.additions.first?.models ?? []).count < self.pageSize
            } else {
                if newState.originals.first!.header == nil {
                    var models = [ModelType].init()
                    models.append(contentsOf: newState.originals.first!.models)
                    models.append(contentsOf: newState.additions.first?.models ?? [])
                    newState.originals = models.count == 0 ? [] : [(header: nil, models: models)]
                    noMore = (newState.additions.first?.models ?? []).count < self.pageSize
                } else {
                    var data = [SectionData].init()
                    data.append(contentsOf: newState.originals)
                    data.append(contentsOf: newState.additions)
                    newState.originals = data
                }
            }
        } else {
            noMore = newState.originals.first?.models.count ?? 0 < self.pageSize
        }
        newState.noMoreData = noMore
        newState.sections = self.genSections(originals: newState.originals)
        return newState
    }
    
    // swiftlint:disable cyclomatic_complexity
    func genSections(originals: [SectionData]) -> [Section] {
        (originals.count == 0 ? [] : originals.map {
            .sectionItems(header: $0.header, items: $0.models.map {
                if let value = ($0 as? BaseModel)?.data as? SectionItemValue {
                    switch value {
                    case .appInfo: return .appInfo(.init($0))
                    case .milestone: return .milestone(.init($0))
                    case .searchOptions: return .searchOptions(.init($0))
                    case .searchKeywords: return .searchKeywords(.init($0))
                    }
                }
                if let user = $0 as? User {
                    switch user.listType {
                    case .none: return .userDetail(.init($0))
                    case .trending: return .userTrending(.init($0))
                    }
                }
                if let repo = $0 as? Repo {
                    switch repo.listType {
                    case .none: return .repoDetail(.init($0))
                    case .trending: return .repoTrending(.init($0))
                    }
                }
                if $0 is Readme {
                    return .readmeContent(.init($0))
                }
//                if $0 is Piece {
//                    return .piece(.init($0))
//                }
//                if let user = $0 as? User {
//                    switch user.cellType {
//                    case .userInfo:
//                        return .userInfo(.init($0))
//                    default:
//                        break
//                    }
//                }
                return .simple(.init($0))
            })
        })
    }
    // swiftlint:enable cyclomatic_complexity
    
    // MARK: - dependency/data
    func loadDependency() -> Observable<Mutation> {
        .empty()
    }
    
    func loadData(_ page: Int) -> Observable<[SectionData]> {
        .empty()
    }
    
    func loadExtra() -> Observable<Mutation> {
        .empty()
    }
    
//    // MARK: - other
//    func eraseAlert() -> Observable<Mutation> {
//        let alert = AppDependency.shared.navigator.rxAlert(
//            "",
//            R.string.localizable.alertLogoutMessage(),
//            [
//                IHAlertAction.cancel,
//                IHAlertAction.default
//            ]
//        ).flatMap { action -> Observable<Mutation> in
//            <#code#>
//        }
//        return .empty()
//    }
    
}

extension NormalViewReactor.Action {
    
    static func isLoad(_ action: NormalViewReactor.Action) -> Bool {
        if case .load = action {
            return true
        }
        return false
    }
    
}
// swiftlint:enable type_body_length
