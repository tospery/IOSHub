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
    
    override func loadData(_ page: Int) -> Observable<[SectionData]> {
        .create { [weak self] observer -> Disposable in
            guard let `self` = self else { fatalError() }
            var models = [ModelType].init()
//            if let user = self.currentState.user, user.isValid {
//                models.append(contentsOf: [
//                    Simple.init(
//                        id: CellId.company.rawValue,
//                        icon: "ic_company",
//                        title: user.company ?? R.string.localizable.noDescription(),
//                        indicated: false
//                    ),
//                    Simple.init(
//                        id: CellId.location.rawValue,
//                        icon: "ic_location",
//                        title: user.location ?? R.string.localizable.noDescription(),
//                        indicated: false
//                    ),
//                    Simple.init(
//                        id: CellId.email.rawValue,
//                        icon: "ic_email",
//                        title: user.email ?? R.string.localizable.noDescription(),
//                        indicated: false
//                    ),
//                    Simple.init(
//                        id: CellId.blog.rawValue,
//                        icon: "ic_blog",
//                        title: user.blog ?? R.string.localizable.noDescription(),
//                        divided: false
//                    )
//                ])
//                models.append(Simple.init(height: 15))
//            }
            let logined = self.currentState.user?.isValid ?? false
            if let simples = Simple.cachedArray(page: self.host) {
                models.append(
                    contentsOf: simples.filter { simple in
                        logined ? true : simple.id < CellId.company.rawValue && simple.id != 0
                    }
                )
            }
            observer.onNext([(header: nil, models: models)])
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
