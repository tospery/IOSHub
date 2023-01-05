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
    }

    override func loadData(_ page: Int) -> Observable<[SectionData]> {
        .create { [weak self] observer -> Disposable in
            guard let `self` = self else { fatalError() }
            if let repos = Repo.cachedArray(page: self.listType.stringValue) {
                observer.onNext([(header: nil, models: repos)])
            }
            return self.provider.trendingRepos()
                 .asObservable()
                 .map { [(header: nil, models: $0)] }
                 .subscribe(observer)
        }
    }
    
}
