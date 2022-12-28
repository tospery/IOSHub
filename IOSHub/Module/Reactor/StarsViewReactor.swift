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
    
    override func loadData(_ page: Int) -> Observable<[SectionData]> {
        .create { [weak self] observer -> Disposable in
            guard let `self` = self else { fatalError() }
            guard let username = self.currentState.user?.username, username.isNotEmpty else {
                observer.onError(HiError.unknown)
                return Disposables.create { }
            }
            return self.provider.trendingUsers()
                 .asObservable()
                 .map { [(header: nil, models: $0)] }
                 .subscribe(observer)
//           return self.provider.starredRepos(username: username, page: page)
//                .asObservable()
//                .map { [(header: nil, models: $0)] }
//                .subscribe(observer)
//                .disposed(by: self.disposeBag)
//            return Disposables.create { }
        }
    }

}
