//
//  UserListViewReactor.swift
//  IOSHub
//
//  Created by 杨建祥 on 2022/12/3.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator
import Rswift
import HiIOS

class UserListViewReactor: NormalViewReactor {
    
    let listType: ListType
    
    required init(_ provider: HiIOS.ProviderType, _ parameters: [String: Any]?) {
        listType = parameters?.enum(for: Parameter.type, type: ListType.self) ?? .trending
        super.init(provider, parameters)
        let users = User.cachedArray(page: self.listType.stringValue) ?? []
        // let total: [HiSection] = users.isNotEmpty ? [(header: nil, models: users)] : []
        let total: [HiSection] = users.isNotEmpty ? [.init(header: nil, models: users)] : []
        let sections = self.genSections(total: total)
        self.initialState = State(
            total: total,
            sections: sections
        )
    }
    
    override func load() -> Observable<Mutation> {
        .concat([
            // .just(.initial([])),
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

//    override func loadData(_ page: Int) -> Observable<[HiSection]> {
//        .create { [weak self] observer -> Disposable in
//            guard let `self` = self else { fatalError() }
////            if let users = User.cachedArray(page: self.listType.stringValue) {
////                observer.onNext([(header: nil, models: users)])
////            }
//            return self.provider.trendingUsers()
//                 .asObservable()
//                 .map { $0.map { user -> User in
//                     var user = user
//                     user.listType = .trending
//                     return user
//                    }
//                 }
//                 .map { [(header: nil, models: $0)] }
//                 .subscribe(observer)
//        }
//    }

}
