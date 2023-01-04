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
import BonMot
import HiIOS

class RepoTrendingItem: BaseCollectionItem, ReactorKit.Reactor {

    typealias Action = NoAction
    typealias Mutation = NoMutation

    struct State {
        var avatar: ImageSource?
        var name: NSAttributedString?
        var lang: NSAttributedString?
        var stars: NSAttributedString?
        // var starsnum: NSAttributedString?
        var desc: String?
    }

    var initialState = State()

    required public init(_ model: ModelType) {
        super.init(model)
        guard let repo = model as? Repo else { return }
        self.initialState = State(
            avatar: repo.owner.avatar?.url,
            name: repo.fullnameAttributedText,
            lang: repo.languageAttributedText,
            stars: repo.starsAttributedText,
            desc: repo.desc ?? R.string.localizable.noneDesc()
        )
    }
    
}
