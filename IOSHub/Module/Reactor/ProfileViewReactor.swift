//
//  ProfileViewReactor.swift
//  IOSHub
//
//  Created by 杨建祥 on 2022/11/27.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator
import Rswift
import HiIOS

class ProfileViewReactor: NormalViewReactor {
    
    required init(_ provider: HiIOS.ProviderType, _ parameters: [String: Any]?) {
        super.init(provider, parameters)
        self.initialState = State(
            title: self.title ?? self.currentState.user?.username
        )
    }
    
    override func loadData(_ page: Int) -> Observable<[SectionData]> {
        guard let simples = Simple.cachedArray(page: self.host) else { return .empty() }
        var models = [ModelType].init()
        models.append(Simple.init(height: 15))
        models.append(contentsOf: simples)
        return .just([(header: nil, models: models)])
    }

}
