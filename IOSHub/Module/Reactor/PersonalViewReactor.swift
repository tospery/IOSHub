//
//  PersonalViewReactor.swift
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
import HiIOS

class PersonalViewReactor: NormalViewReactor {
    
    required init(_ provider: HiIOS.ProviderType, _ parameters: [String: Any]?) {
        super.init(provider, parameters)
        self.initialState = State(
            title: self.title ?? R.string.localizable.mine()
        )
    }
    
    override func loadData(_ page: Int) -> Observable<[HiSection]> {
        .create { [weak self] observer -> Disposable in
            guard let `self` = self else { fatalError() }
            var models = [ModelType].init()
            let logined = self.currentState.user?.isValid ?? false
//            if logined {
//                models.append(BaseModel.init(SectionItemValue.milestone))
//            }
            if let simples = Simple.cachedArray(page: self.host) {
                models.append(
                    contentsOf: simples.filter { simple in
                        logined ? true : simple.id < CellId.company.rawValue && simple.id != 0
                    }
                )
            }
            observer.onNext([.init(header: nil, models: models)])
            observer.onCompleted()
            return Disposables.create { }
        }
    }
    
//    override func loadExtra() -> Observable<NormalViewReactor.Mutation> {
//        self.reload()
//    }
    
//    override func reload() -> Observable<NormalViewReactor.Mutation> {
//        return .concat([
//            .just(.setError(nil)),
//            .just(.setRefreshing(true)),
//            .merge([
//                self.provider.userinfo()
//                    .asObservable()
//                    .flatMap { user -> Observable<User?> in
//                        return .just(user)
//                    }
//                    .catchAndReturn(nil)
//                    .map(Mutation.setUser),
//                self.provider.sharedCount()
//                    .asObservable()
//                    .catchAndReturn(0)
//                    .map { [weak self] count -> Preference in
//                        guard let `self` = self else { fatalError() }
//                        var pref = self.currentState.preference
//                        pref.shared = count
//                        return pref
//                    }
//                    .map(Mutation.setPreference),
//                self.provider.bannerCards()
//                    .asObservable()
//                    .map(Mutation.setCards)
//            ]),
//            .just(.setRefreshing(false))
//        ]).catch({
//            .concat([
//                .just(.setError($0)),
//                .just(.setRefreshing(false))
//            ])
//        })
//    }

}
