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
    
    var languageAttributedText: NSAttributedString {
        .composed(of: [
            "●".styled(with: .color(self.languageColor?.color ?? .random)),
            Special.space,
            (self.language ?? R.string.localizable.unknown()).styled(with: .color(.title))
        ]).styled(with: .font(.normal(12)))
    }
    
    var starsnumAttributedText: NSAttributedString {
        .composed(of: [
            R.image.ic_star()!.template.styled(with: .baselineOffset(-2), .color(.title)),
            Special.space,
            self.stars.formatted.styled(with: .color(.title))
        ]).styled(with: .font(.normal(11)))
    }
    
    var descAttributedText: NSAttributedString? {
        (self.desc ?? R.string.localizable.noneDesc()).styled(
            with: .font(.normal(15)), .color(.title),
            .lineHeightMultiple(1.1),
            .lineBreakMode(.byTruncatingTail)
        )
    }
    
}
