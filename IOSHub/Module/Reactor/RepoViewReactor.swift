//
//  RepoViewReactor.swift
//  IOSHub
//
//  Created by 杨建祥 on 2022/12/24.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator
import Rswift
import HiIOS

class RepoViewReactor: NormalViewReactor {
    
    required init(_ provider: HiIOS.ProviderType, _ parameters: [String: Any]?) {
        super.init(provider, parameters)
        self.initialState = State(
            title: self.title ?? R.string.localizable.repository()
        )
    }
    
    override func requestDependency() -> Observable<Mutation> {
        .create { [weak self] observer -> Disposable in
            guard let `self` = self else { fatalError() }
            guard let username = self.username, let reponame = self.reponame else {
                observer.onError(HiError.unknown)
                return Disposables.create { }
            }
            return Observable.zip([
                self.provider.repo(username: username, reponame: reponame)
                    .asObservable()
                    .map { Dataset.init(repo: $0) },
                self.provider.readme(username: username, reponame: reponame, ref: nil)
                    .asObservable()
                    .map { Dataset.init(readme: $0) }
            ])
                .map { Mutation.setDataset(.init(repo: $0[0].repo, readme: $0[1].readme)) }
                .subscribe(observer)
        }
    }
    
    override func requestData(_ page: Int) -> Observable<[HiSection]> {
        .create { [weak self] observer -> Disposable in
            guard let `self` = self else { fatalError() }
            var models = [ModelType].init()
            if let repo = self.currentState.repo {
                models.append(repo)
                let cellIds: [CellId] = [.space, .language, .issues, .pullrequests, .space, .branches, .readme]
                let simples = cellIds.map { id -> Simple in
                    if id == .space {
                        return .init(height: 10)
                    }
                    var title = id.title
                    if title?.isEmpty ?? true {
                        if id == .language {
                            title = repo.language
                        }
                    }
                    return .init(id: id.rawValue, icon: id.icon, title: title)
                }
                models.append(contentsOf: simples)
            }
            if let readme = self.currentState.readme {
                models.append(readme)
            }
            observer.onNext([.init(header: nil, models: models)])
            observer.onCompleted()
            return Disposables.create { }
        }
    }
    
    override func reload(_ data: Any?) -> Observable<Mutation> {
        guard let readme = data as? Readme else { return .empty() }
        return .concat([
            .just(.setReadme(readme)),
            self.requestData(self.pageStart)
                .map(Mutation.initial)
        ])
    }
    
    override func reduce(state: State, mutation: Mutation) -> State {
        var newState = super.reduce(state: state, mutation: mutation)
        switch mutation {
        case let .setDataset(dataset):
            newState.repo = dataset?.repo
            newState.readme = dataset?.readme
        default:
            break
        }
        return newState
    }

}
