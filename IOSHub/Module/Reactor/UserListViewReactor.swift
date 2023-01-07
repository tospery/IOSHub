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
    }
    
    override func fetchLocal() -> Observable<[HiSection]> {
        let models = User.cachedArray(page: self.listType.stringValue) ?? []
        let original: [HiSection] = models.isNotEmpty ? [.init(header: nil, models: models)] : []
        return .just(original)
    }

    override func requestData(_ page: Int) -> Observable<[HiSection]> {
        .create { [weak self] observer -> Disposable in
            guard let `self` = self else { fatalError() }
            return self.provider.trendingUsers()
                 .asObservable()
                 .map { $0.map { user -> User in
                     var user = user
                     user.listType = .trending
                     return user
                    }
                 }
                 .map { [.init(header: nil, models: $0)] }
                 .subscribe(observer)
        }
    }

}
