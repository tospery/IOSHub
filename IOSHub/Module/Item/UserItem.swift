//
//  UserBasicItem.swift
//  IOSHub
//
//  Created by 杨建祥 on 2022/11/30.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator
import Rswift
import HiIOS

class UserBasicItem: BaseCollectionItem, ReactorKit.Reactor {

    typealias Action = NoAction
    typealias Mutation = NoMutation

    struct State {
        var fullname: NSAttributedString?
        var repoName: NSAttributedString?
        var repoDesc: String?
        var avatar: ImageSource?
    }

    var initialState = State()

    required public init(_ model: ModelType) {
        super.init(model)
        guard let user = model as? User else { return }
        self.initialState = State(
            fullname: user.attrFullname,
            repoName: user.attrRepoName,
            repoDesc: user.repoDesc,
            avatar: user.avatar?.url
        )
    }
    
}
