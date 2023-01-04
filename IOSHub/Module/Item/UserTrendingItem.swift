//
//  UserTrendingItem.swift
//  IOSHub
//
//  Created by 杨建祥 on 2023/1/5.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator
import Rswift
import BonMot
import HiIOS

class UserTrendingItem: BaseCollectionItem, ReactorKit.Reactor {

    typealias Action = NoAction
    typealias Mutation = NoMutation

    struct State {
        var avatar: ImageSource?
        var name: NSAttributedString?
        var repo: NSAttributedString?
        var desc: String?
    }

    var initialState = State()

    required public init(_ model: ModelType) {
        super.init(model)
        guard let user = model as? User else { return }
        self.initialState = State(
            avatar: user.avatar?.url,
            name: user.fullnameAttributedText,
            repo: user.repoAttributedText,
            desc: user.repo?.desc ?? R.string.localizable.noneDesc()
        )
    }
    
}
