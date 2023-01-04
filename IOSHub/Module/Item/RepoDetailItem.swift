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
        var avatar: ImageSource?
        var name: NSAttributedString?
        var lang: NSAttributedString?
        var update: String?
        var desc: String?
        var repo: Repo?
    }

    var initialState = State()

    required public init(_ model: ModelType) {
        super.init(model)
        guard let repo = model as? Repo else { return }
        self.initialState = State(
            avatar: repo.owner.avatar?.url,
            name: repo.fullnameAttributedText.styled(with: .font(.bold(18))),
            lang: repo.languageAttributedText,
            update: repo.updateAgo,
            desc: repo.desc ?? R.string.localizable.noneDesc(),
            repo: repo
        )
    }
    
}
