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
    
    let displayMode: DisplayMode
    
    required init(_ provider: HiIOS.ProviderType, _ parameters: [String: Any]?) {
        displayMode = parameters?.enum(for: Parameter.type, type: DisplayMode.self) ?? .list
        super.init(provider, parameters)
    }
    
    override func fetchLocal() -> Observable<[HiSection]> {
        let models = Repo.cachedArray(page: self.displayMode.stringValue) ?? []
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
                     repo.displayMode = .list
                     return repo
                    }
                 }
                 .map { [.init(header: nil, models: $0)] }
                 .subscribe(observer)
        }
    }
    
}
