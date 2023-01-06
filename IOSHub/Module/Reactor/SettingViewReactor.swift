//
//  SettingViewReactor.swift
//  IOSHub
//
//  Created by 杨建祥 on 2023/1/7.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator
import Rswift
import HiIOS

class SettingViewReactor: NormalViewReactor {
    
    required init(_ provider: HiIOS.ProviderType, _ parameters: [String: Any]?) {
        super.init(provider, parameters)
        self.initialState = State(
            title: self.title ?? R.string.localizable.setting()
        )
    }
    
    override func loadData(_ page: Int) -> Observable<[HiSection]> {
        guard let simples = Simple.cachedArray(page: self.host) else { return .empty() }
        var models = [ModelType].init()
        models.append(contentsOf: simples)
        return .just([.init(header: nil, models: models)])
    }

}
