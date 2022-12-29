//
//  ReadmeContentItem.swift
//  IOSHub
//
//  Created by 杨建祥 on 2022/12/30.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator
import Rswift
import HiIOS

class ReadmeContentItem: BaseCollectionItem, ReactorKit.Reactor {

    typealias Action = NoAction
    typealias Mutation = NoMutation

    struct State {
        var html: String?
    }

    var initialState = State()

    required public init(_ model: ModelType) {
        super.init(model)
        guard let readme = model as? Readme else { return }
        self.initialState = State(
            html: readme.html
        )
    }
    
}
