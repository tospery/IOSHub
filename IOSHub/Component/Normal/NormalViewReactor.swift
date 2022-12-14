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
        case activate(Any?)
        case target(String)
        case value(Any?)
        case back(String?)
    }

    enum Mutation {
        case setLoading(Bool)
        case setRefreshing(Bool)
        case setLoadingMore(Bool)
        case setActivating(Bool)
        case setFollowed(Bool?)
        case setEnabled(Bool?)
        case setError(Error?)
        case setTitle(String?)
        case setBack(String?)
        case setTarget(String?)
        case setValue(Any?)
        case setRepo(Repo?)
        case setReadme(Readme?)
        case setDataset(Dataset?)
        case setUser(User?)
        case setConfiguration(Configuration)
        case initial([HiSection])
        case append([HiSection])
    }

    struct State {
        var isLoading = false
        var isRefreshing = false
        var isLoadingMore = false
        var isActivating = false
        var isEnabled: Bool?
        var isFollowed: Bool?
        var noMoreData = false
        var error: Error?
        var title: String?
        var back: String?
        var target: String?
        var value: Any?
        var repo: Repo?
        var readme: Readme?
        var dataset: Dataset?
        var user = User.current
        var configuration = Configuration.current!
        var total = [HiSection].init()
        var added = [HiSection].init()
        var sections = [Section].init()
    }

    struct Dataset {
        var isFollowed: Bool?
        var user: User?
        var repo: Repo?
        var readme: Readme?
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
        case let .activate(data):
            return self.activate(data)
        case let .target(target):
            return .concat([
                .just(.setTarget(nil)),
                .just(.setTarget(target))
            ])
        case let .value(value):
            return .just(.setValue(value))
        case let .back(back):
            return .just(.setBack(back))
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
        case let .setEnabled(isEnabled):
            newState.isEnabled = isEnabled
        case let .setFollowed(isFollowed):
            newState.isFollowed = isFollowed
        case let .setError(error):
            newState.error = error
        case let .setTitle(title):
            newState.title = title
        case let .setBack(back):
            newState.back = back
        case let .setTarget(target):
            newState.target = target
        case let .setValue(value):
            newState.value = value
        case let .setRepo(repo):
            newState.repo = repo
        case let .setReadme(readme):
            newState.readme = readme
        case let .setDataset(dataset):
            newState.dataset = dataset
        case let .setUser(user):
            newState.user = user
        case let .setConfiguration(configuration):
            newState.configuration = configuration
        case let .initial(data):
            newState.total = data
            return self.reduceSections(newState, additional: false)
        case let .append(added):
            newState.added = added
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
            self.fetchLocal()
                .map(Mutation.initial),
            .just(.setError(nil)),
            .just(.setLoading(true)),
            self.requestDependency(),
            self.requestData(self.pageStart)
                .map(Mutation.initial),
            .just(.setLoading(false)),
            self.requestExtra()
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
            self.requestData(self.pageStart)
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
            self.requestData(self.pageIndex + 1)
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
    
    func business(_ data: Any?) -> Observable<Mutation> {
        .empty()
    }
    
    func silent(_ data: Any?) -> Observable<Mutation> {
        .empty()
    }
    
    // MARK: - fetch
    func fetchLocal() -> Observable<[HiSection]> {
        .just([])
    }
    
    // MARK: - request
    func requestDependency() -> Observable<Mutation> {
        .empty()
    }
    
    func requestData(_ page: Int) -> Observable<[HiSection]> {
        .empty()
    }
    
    func requestExtra() -> Observable<Mutation> {
        .empty()
    }
    
    // MARK: - sections
    func reduceSections(_ state: State, additional: Bool) -> State {
        var newState = state
        var noMore = false
        if additional {
            if newState.total.isEmpty {
                newState.total = newState.added
                noMore = (newState.added.first?.models ?? []).count < self.pageSize
            } else {
                if newState.total.first!.header == nil {
                    var models = [ModelType].init()
                    models.append(contentsOf: newState.total.first!.models)
                    models.append(contentsOf: newState.added.first?.models ?? [])
                    newState.total = models.count == 0 ? [] : [.init(header: nil, models: models)]
                    noMore = (newState.added.first?.models ?? []).count < self.pageSize
                } else {
                    var data = [HiSection].init()
                    data.append(contentsOf: newState.total)
                    data.append(contentsOf: newState.added)
                    newState.total = data
                }
            }
        } else {
            noMore = newState.total.first?.models.count ?? 0 < self.pageSize
        }
        newState.noMoreData = noMore
        newState.sections = self.genSections(total: newState.total)
        return newState
    }
    
    // swiftlint:disable cyclomatic_complexity
    func genSections(total: [HiSection]) -> [Section] {
        (total.count == 0 ? [] : total.map {
            .sectionItems(header: $0.header, items: $0.models.map {
                if let value = ($0 as? BaseModel)?.data as? SectionItemValue {
                    switch value {
                    case .submit: return .submit(.init($0))
                    case .appInfo: return .appInfo(.init($0))
                    case .milestone: return .milestone(.init($0))
                    case .searchOptions: return .searchOptions(.init($0))
                    case .searchKeywords: return .searchKeywords(.init($0))
                    case .feedbackNote: return .feedbackNote(.init($0))
                    case .feedbackInput: return .feedbackInput(.init($0))
                    }
                }
                if let user = $0 as? User {
                    switch user.displayMode {
                    case .none: return .userDetail(.init($0))
                    case .list: return .userTrending(.init($0))
                    }
                }
                if let repo = $0 as? Repo {
                    switch repo.displayMode {
                    case .none: return .repoDetail(.init($0))
                    case .list: return .repoTrending(.init($0))
                    }
                }
                if $0 is Readme {
                    return .readmeContent(.init($0))
                }
                if $0 is Event {
                    return .event(.init($0))
                }
                return .simple(.init($0))
            })
        })
    }
    // swiftlint:enable cyclomatic_complexity
    
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
