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
        self.initialState = State(
            user: nil
        )
    }
    
    override func loadDependency() -> Observable<Mutation> {
        if self.username == nil {
            return .error(HiError.unknown)
        }
        // 注：merge执行完completed，才进入下一步的loadData，而不是每个next都执行一次loadData
        return .merge([
            self.provider.user(username: self.username)
                .asObservable()
                .map(Mutation.setUser),
            self.provider.checkFollow(username: self.username)
                .asObservable()
                .map(Mutation.setFollowed)
        ])
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
    
    override func business(_ data: Any?) -> Observable<Mutation> {
        .create { [weak self] observer -> Disposable in
            guard let `self` = self else { fatalError() }
            if self.username == nil || self.currentState.isFollowed == nil {
                observer.onError(HiError.unknown)
                return Disposables.create { }
            }
            if self.currentState.isFollowed! {
                return self.provider.unFollow(username: self.username)
                    .asObservable()
                    .mapTo(Mutation.setFollowed(false))
                    .subscribe(observer)
            } else {
                return self.provider.follow(username: self.username)
                    .asObservable()
                    .mapTo(Mutation.setFollowed(true))
                    .subscribe(observer)
            }
        }
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

}
