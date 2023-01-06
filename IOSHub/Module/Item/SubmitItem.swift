//
//  SubmitItem.swift
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

class SubmitItem: BaseCollectionItem, ReactorKit.Reactor {

    enum Action {
        case enable(Bool?)
    }
    
    enum Mutation {
        case setEnabled(Bool?)
    }

    struct State {
        var isEnabled: Bool?
    }

    var initialState = State()

    required public init(_ model: ModelType) {
        super.init(model)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .enable(isEnabled):
            return .just(.setEnabled(isEnabled))
        }
    }
        
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setEnabled(isEnabled):
            newState.isEnabled = isEnabled
        }
        return newState
    }
    
}
