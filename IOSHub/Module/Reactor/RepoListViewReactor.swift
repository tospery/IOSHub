//
//  RepoListViewReactor.swift
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

class RepoListViewReactor: NormalViewReactor {
    
    let listType: ListType
    
    required init(_ provider: HiIOS.ProviderType, _ parameters: [String: Any]?) {
        listType = parameters?.enum(for: Parameter.type, type: ListType.self) ?? .trending
        super.init(provider, parameters)
        let repos = Repo.cachedArray(page: self.listType.stringValue) ?? []
        let originals: [SectionData] = repos.isNotEmpty ? [(header: nil, models: repos)] : []
        let sections = self.genSections(originals: originals)
        self.initialState = State(
            originals: originals,
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

//    override func loadData(_ page: Int) -> Observable<[SectionData]> {
//        .create { [weak self] observer -> Disposable in
//            guard let `self` = self else { fatalError() }
////            if let repos = Repo.cachedArray(page: self.listType.stringValue) {
////                observer.onNext([(header: nil, models: repos)])
////            }
//            return self.provider.trendingRepos()
//                 .asObservable()
//                 .map { $0.map { repo -> Repo in
//                     var repo = repo
//                     repo.listType = .trending
//                     return repo
//                    }
//                 }
//                 .map { [(header: nil, models: $0)] }
//                 .subscribe(observer)
//        }
//    }
    
}
