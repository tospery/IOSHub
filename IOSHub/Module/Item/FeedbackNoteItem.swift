//
//  FeedbackNoteItem.swift
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

class FeedbackNoteItem: BaseCollectionItem, ReactorKit.Reactor {

    typealias Action = NoAction
    typealias Mutation = NoMutation
    
    struct State {
        var text: NSAttributedString?
    }

    var initialState = State()

    required public init(_ model: ModelType) {
        super.init(model)
    }
    
}
