//
//  AboutViewReactor.swift
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

class AboutViewReactor: NormalViewReactor {
    
    required init(_ provider: HiIOS.ProviderType, _ parameters: [String: Any]?) {
        super.init(provider, parameters)
        self.initialState = State(
            title: self.title ?? R.string.localizable.about()
        )
    }
    
    override func loadData(_ page: Int) -> Observable<[HiSection]> {
        guard let simples = Simple.cachedArray(page: self.host) else { return .empty() }
        var models = [ModelType].init()
        models.append(BaseModel.init(SectionItemValue.appInfo))
        models.append(contentsOf: simples)
        // return .just([(header: nil, models: models)])
        return .just([.init(header: nil, models: models)])
    }

}
