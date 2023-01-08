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

    enum Action {
        case option(Int)
    }
    
    enum Mutation {
        case setOption(Int)
    }

    struct State {
        var option = 0
    }

    var initialState = State()

    required public init(_ model: ModelType) {
        super.init(model)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .option(option):
            return .just(.setOption(option))
        }
    }
        
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setOption(option):
            newState.option = option
        }
        return newState
    }
    
}
