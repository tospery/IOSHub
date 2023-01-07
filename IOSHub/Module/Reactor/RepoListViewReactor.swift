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
    
    override func fetchLocal() -> Observable<[HiSection]> {
        let models = Repo.cachedArray(page: self.listType.stringValue) ?? []
        let original: [HiSection] = models.isNotEmpty ? [.init(header: nil, models: models)] : []
        return .just(original)
    }

    override func requestData(_ page: Int) -> Observable<[HiSection]> {
        .create { [weak self] observer -> Disposable in
            guard let `self` = self else { fatalError() }
            return self.provider.trendingRepos()
                 .asObservable()
                 .map { $0.map { repo -> Repo in
                     var repo = repo
                     repo.listType = .trending
                     return repo
                    }
                 }
                 .map { [.init(header: nil, models: $0)] }
                 .subscribe(observer)
        }
    }
    
}
