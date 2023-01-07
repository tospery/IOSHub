//
//  EventItem.swift
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

class EventItem: BaseCollectionItem, ReactorKit.Reactor {

    typealias Action = NoAction
    typealias Mutation = NoMutation

    struct State {
        var title: String?
        var time: String?
        var content: [NSAttributedString]?
        var icon: ImageSource?
    }

    var initialState = State()

    required public init(_ model: ModelType) {
        super.init(model)
        guard let event = model as? Event else { return }
        self.initialState = State(
            title: event.type.title,
            time: event.time,
            content: event.content,
            icon: event.type.icon
        )
    }
    
}
