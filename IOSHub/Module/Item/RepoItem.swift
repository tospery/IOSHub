//
//  RepoItem.swift
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

class RepoItem: BaseCollectionItem, ReactorKit.Reactor {

    typealias Action = NoAction
    typealias Mutation = NoMutation

    struct State {
//        var name: NSAttributedString?
//        var language: NSAttributedString?
//        var stars: NSAttributedString?
        var repo: Repo?
        var desc: NSAttributedString?
    }

    var initialState = State()

    required public init(_ model: ModelType) {
        super.init(model)
        guard let repo = model as? Repo else { return }
        self.initialState = State(
//            name: repo.fullnameAttributedText,
//            language: repo.languageAttributedText,
//            stars: repo.starsAttributedText,
            repo: repo,
            desc: repo.descAttributedText
        )
    }
    
}
