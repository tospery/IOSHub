//
//  EventViewReactor.swift
//  IOSHub
//
//  Created by 杨建祥 on 2022/11/30.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator
import Rswift
import HiIOS

class EventViewReactor: NormalViewReactor {
    
    required init(_ provider: HiIOS.ProviderType, _ parameters: [String: Any]?) {
        super.init(provider, parameters)
        self.pageStart = 1
        self.pageIndex = self.pageStart
        self.initialState = State(
            title: self.title ?? R.string.localizable.event()
        )
    }
    
    override func fetchLocal() -> Observable<[HiSection]> {
          let models = Event.cachedArray(page: self.host) ?? []
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
            return self.provider.userEvents(username: username, page: page)
                .asObservable()
                .map { [.init(header: nil, models: $0)] }
                .subscribe(observer)
        }
    }

}
