//
//  HistoryViewReactor.swift
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

class HistoryViewReactor: NormalViewReactor {
    
    required init(_ provider: HiIOS.ProviderType, _ parameters: [String: Any]?) {
        super.init(provider, parameters)
        self.initialState = State(
            title: self.title
        )
    }
    
    override func loadData(_ page: Int) -> Observable<[SectionData]> {
        // guard let simples = Simple.cachedArray(page: self.host) else { return .empty() }
        var models = [ModelType].init()
        models.append(BaseModel.init(SectionItemValue.searchOptions))
        // models.append(contentsOf: simples)
        return .just([(header: nil, models: models)])
    }

}
