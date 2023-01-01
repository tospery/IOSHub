//
//  UserViewReactor.swift
//  IOSHub
//
//  Created by 杨建祥 on 2022/12/30.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator
import Rswift
import HiIOS

class UserViewReactor: NormalViewReactor {
    
    required init(_ provider: HiIOS.ProviderType, _ parameters: [String: Any]?) {
        super.init(provider, parameters)
    }
    
    override func loadDependency() -> Observable<Mutation> {
        .create { [weak self] observer -> Disposable in
            guard let `self` = self else { fatalError() }
            if self.username == nil {
                observer.onError(HiError.unknown)
                return Disposables.create { }
            }
            return self.provider.user(username: self.username)
                .asObservable()
                .map(Mutation.setUser)
                .subscribe(observer)
        }
    }
    
    override func loadData(_ page: Int) -> Observable<[SectionData]> {
        .create { [weak self] observer -> Disposable in
            guard let `self` = self else { fatalError() }
            var models = [ModelType].init()
            if var user = self.currentState.user {
                user.cellType = .detail
                models.append(user)
                if user.isOrganization {
                    models.append(Simple.init(height: 10))
                } else {
                    models.append(BaseModel.init(SectionItemValue.milestone))
                }
                models.append(
                    contentsOf: [
                        CellId.company, CellId.location, CellId.email, CellId.blog
                    ].map { id -> Simple in
                        return .init(id: id.rawValue, icon: id.icon, title: id.title)
                    }
                )
            }
            observer.onNext([(header: nil, models: models)])
            observer.onCompleted()
            return Disposables.create { }
        }
    }
    
    override func reduce(state: State, mutation: Mutation) -> State {
        var newState = super.reduce(state: state, mutation: mutation)
        switch mutation {
        case let .setUser(user):
            newState.title = user?.type
        default:
            break
        }
        return newState
    }
    
    override func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        .merge(
            mutation,
            Subjection.for(Configuration.self)
                .distinctUntilChanged()
                .filterNil()
                .asObservable()
                .map(Mutation.setConfiguration)
        )
    }
    
//
//    override func reload(_ data: Any?) -> Observable<NormalViewReactor.Mutation> {
//        guard let readme = data as? Readme else { return .empty() }
//        log("开始重新加载readme = \(readme.heights)")
//        return .concat([
//            .just(.setReadme(readme)),
//            self.loadData(self.pageStart)
//                .map(Mutation.initial)
//        ])
//    }

}
