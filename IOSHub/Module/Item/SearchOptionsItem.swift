//
//  SearchOptionsItem.swift
//  IOSHub
//
//  Created by 杨建祥 on 2022/12/12.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator
import Rswift
import HiIOS

class SearchOptionsItem: BaseCollectionItem, ReactorKit.Reactor {

    typealias Action = NoAction
    typealias Mutation = NoMutation

    struct State {
    }

    var initialState = State()

    required public init(_ model: ModelType) {
        super.init(model)
    }
    
}
