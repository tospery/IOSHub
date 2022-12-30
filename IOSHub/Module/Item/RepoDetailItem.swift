//
//  RepoDetailItem.swift
//  IOSHub
//
//  Created by 杨建祥 on 2022/12/28.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator
import Rswift
import HiIOS

class RepoDetailItem: BaseCollectionItem, ReactorKit.Reactor {

    typealias Action = NoAction
    typealias Mutation = NoMutation

    struct State {
        var repo: Repo?
        var avatar: ImageSource?
        var updateAgo: String?
        var name: NSAttributedString?
        var desc: NSAttributedString?
    }

    var initialState = State()

    required public init(_ model: ModelType) {
        super.init(model)
        guard let repo = model as? Repo else { return }
        self.initialState = State(
            repo: repo,
            avatar: repo.owner.avatar?.url,
            updateAgo: repo.updateAgo,
            name: repo.attrFullname,
            desc: repo.attrDesc
        )
    }
    
}
