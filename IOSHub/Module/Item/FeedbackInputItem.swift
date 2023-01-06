//
//  FeedbackInputItem.swift
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

class FeedbackInputItem: BaseCollectionItem, ReactorKit.Reactor {

    typealias Action = NoAction
    typealias Mutation = NoMutation
    
    struct State {
        var title: String?
    }

    var initialState = State()

    required public init(_ model: ModelType) {
        super.init(model)
        self.initialState = State(
            title: R.string.localizable.feedbackEnvironment(
                UIDevice.current.modelName,
                UIDevice.current.systemVersion,
                UIApplication.shared.version!,
                UIApplication.shared.buildNumber!
            )
        )
    }
    
}
