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
import BonMot
import HiIOS

class UserBasicItem: BaseCollectionItem, ReactorKit.Reactor {

    typealias Action = NoAction
    typealias Mutation = NoMutation

    struct State {
        var avatar: ImageSource?
        var userName: NSAttributedString?
        var repoName: NSAttributedString?
        var desc: String?
    }

    var initialState = State()

    required public init(_ model: ModelType) {
        super.init(model)
        guard let user = model as? User else { return }
        self.initialState = State(
            avatar: user.avatar?.url,
            userName: .composed(of: [
                (user.nickname ?? R.string.localizable.unknown())
                    .styled(with: .color(.primary)),
                Special.space,
                "(\(user.username ?? R.string.localizable.unknown()))"
                    .styled(with: .color(.title))
            ]).styled(with: .font(.normal(16))),
            repoName: .composed(of: [
                R.image.ic_repo_small()!
                    .styled(with: .baselineOffset(-4)),
                Special.space,
                (user.repo?.name ?? R.string.localizable.noneRepo())
                    .attributedString()
            ]).styled(with: .color(.title), .font(.normal(14))),
            desc: user.repo?.desc ?? R.string.localizable.noneDesc()
        )
    }
    
}
