//
//  StarsViewReactor.swift
//  IOSHub
//
//  Created by 杨建祥 on 2022/11/29.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator
import Rswift
import HiIOS

class StarsViewReactor: NormalViewReactor {
    
    required init(_ provider: HiIOS.ProviderType, _ parameters: [String: Any]?) {
        super.init(provider, parameters)
        self.initialState = State(
            title: self.title ?? R.string.localizable.collect()
        )
    }
    
    override func fetchLocal() -> Observable<[HiSection]> {
        let models = Repo.cachedArray(page: self.host) ?? []
        let original: [HiSection] = models.isNotEmpty ? [.init(header: nil, models: models)] : []
        return .just(original)
    }
    
    override func requestData(_ page: Int) -> Observable<[HiSection]> {
        .create { [weak self] observer -> Disposable in
            guard let `self` = self else { fatalError() }
            guard let username = self.currentState.user?.username, username.isNotEmpty else {
                observer.onError(HiError.userNotLoginedIn)
                return Disposables.create { }
            }
            return self.provider.starredRepos(username: username, page: page)
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
