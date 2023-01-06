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
        models.append(BaseModel.init(SectionItemValue.feedbackInput))
        models.append(BaseModel.init(SectionItemValue.submit))
        models.append(BaseModel.init(SectionItemValue.feedbackNote))
        return .just([.init(header: nil, models: models)])
    }
    
    override func business(_ data: Any?) -> Observable<Mutation> {
        .create { [weak self] observer -> Disposable in
            guard let `self` = self else { fatalError() }
            guard let texts = self.currentState.value as? [String],
                  let title = texts.first, let body = texts.last, title.isNotEmpty, body.isNotEmpty else {
                observer.onError(HiError.unknown)
                return Disposables.create { }
            }
            return self.provider.feedback(title: body, body: title)
                .asObservable()
                .mapTo(Mutation.setBack(R.string.localizable.toastSubmitMessage()))
                .subscribe(observer)
        }
    }

}
