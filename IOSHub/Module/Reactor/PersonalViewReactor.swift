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
    
    override func requestData(_ page: Int) -> Observable<[HiSection]> {
        .create { [weak self] observer -> Disposable in
            guard let `self` = self else { fatalError() }
            var models = [ModelType].init()
            let logined = self.currentState.user?.isValid ?? false
            if let simples = Simple.cachedArray(page: self.host) {
//                models.append(
//                    contentsOf: simples.filter { simple in
//                        logined ? true : simple.id < CellId.company.rawValue && simple.id != 0
//                    }
//                )
                for simple in simples {
                    if logined {
                        if simple.id == CellId.blog.rawValue {
                            var new = simple
                            new.target = self.currentState.user?.blog
                            models.append(new)
                        } else {
                            models.append(simple)
                        }
                    } else {
                        if simple.id < CellId.company.rawValue && simple.id != 0 {
                            models.append(simple)
                        }
                    }
                }
            }
            observer.onNext([.init(header: nil, models: models)])
            observer.onCompleted()
            return Disposables.create { }
        }
    }

}
