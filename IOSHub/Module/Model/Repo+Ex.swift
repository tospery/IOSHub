//
//  Repo+Ex.swift
//  IOSHub
//
//  Created by 杨建祥 on 2022/11/29.
//

import Foundation
import BonMot
import DateToolsSwift_JX
import HiIOS

extension Repo {
    
    var updateAgo: String? {
        guard let string = self.updatedAt else { return nil }
        guard let date = Date.init(iso8601: string) else { return nil }
        return R.string.localizable.latestUpdate(date.timeAgoSinceNow)
    }
    
    var fullnameAttributedText: NSAttributedString {
        "\(self.owner.username ?? R.string.localizable.unknown()) / \(self.name ?? R.string.localizable.unknown())"
            .styled(with: .color(.primary), .font(.bold(16)))
    }
    
    var langstarsAttributedText: NSAttributedString {
        .composed(of: [
            "●".styled(with: .color(self.languageColor?.color ?? .random)),
            Special.space,
            (self.language ?? R.string.localizable.unknown()).styled(with: .color(.foreground)),
            Special.space,
            Special.space,
            R.image.ic_star()!.template.styled(with: .baselineOffset(-2), .color(.foreground)),
            Special.space,
            self.stars.formatted.styled(with: .color(.foreground))
        ]).styled(with: .font(.normal(13)))
    }
    
    var languageAttributedText: NSAttributedString {
        .composed(of: [
            "●".styled(with: .color(self.languageColor?.color ?? .random)),
            Special.space,
            (self.language ?? R.string.localizable.unknown()).styled(with: .color(.foreground))
        ]).styled(with: .font(.normal(13)))
    }
    
    var starsAttributedText: NSAttributedString {
        .composed(of: [
            R.image.ic_star()!.template
                .styled(with: .baselineOffset(-2), .font(.normal(10))),
            Special.space,
            self.stars.formatted
                .styled(with: .font(.normal(11)))
        ]).styled(with: .color(.title))
    }
    
//    var descAttributedText: NSAttributedString? {
//        (self.desc ?? R.string.localizable.noneDesc()).styled(
//            with: .font(.normal(15)), .color(.title),
//            .lineHeightMultiple(1.1),
//            .lineBreakMode(.byTruncatingTail)
//        )
//    }
    
    mutating func setup(displayMode: DisplayMode) {
        var repo = self
        repo.displayMode = displayMode
        self = repo
    }
    
}
