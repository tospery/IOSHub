//
//  FeedbackViewReactor.swift
//  IOSHub
//
//  Created by 杨建祥 on 2023/1/6.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator
import Rswift
import HiIOS

class FeedbackViewReactor: NormalViewReactor {
    
    required init(_ provider: HiIOS.ProviderType, _ parameters: [String: Any]?) {
        super.init(provider, parameters)
        self.initialState = State(
            title: self.title ?? R.string.localizable.feedback()
        )
    }
    
    override func loadData(_ page: Int) -> Observable<[HiSection]> {
        var models = [ModelType].init()
        models.append(BaseModel.init(SectionItemValue.feedbackNote))
        return .just([.init(header: nil, models: models)])
    }

}
