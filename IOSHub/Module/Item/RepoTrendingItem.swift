//
//  RepoTrendingItem.swift
//  IOSHub
//
//  Created by 杨建祥 on 2022/11/29.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator
import Rswift
import HiIOS

class RepoTrendingItem: BaseCollectionItem, ReactorKit.Reactor {

    typealias Action = NoAction
    typealias Mutation = NoMutation

    struct State {
        var avatar: ImageSource?
        var fullname: NSAttributedString?
        var language: NSAttributedString?
        var starsnum: NSAttributedString?
        var desc: NSAttributedString?
    }

    var initialState = State()

    required public init(_ model: ModelType) {
        super.init(model)
        guard let repo = model as? Repo else { return }
        self.initialState = State(
            avatar: repo.owner.avatar?.url,
            fullname: repo.fullnameAttributedText,
            language: repo.languageAttributedText,
            starsnum: repo.starsnumAttributedText,
            desc: repo.descAttributedText
        )
    }
    
}
