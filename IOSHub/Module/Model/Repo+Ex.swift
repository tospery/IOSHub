//
//  Repo+Ex.swift
//  IOSHub
//
//  Created by 杨建祥 on 2022/11/29.
//

import Foundation
import BonMot
import HiIOS

extension Repo {
    
    var attrFullname: NSAttributedString {
//        if let name = self.fullname {
//            return name.styled(with: .color(.title), .font(.normal(17)))
//        }
//        return "\(owner.username ?? "")/\(name ?? "")".styled(with: .color(.title), .font(.normal(17)))
        return (self.fullname ?? R.string.localizable.unknown()).styled(with: .color(.title), .font(.normal(17)))
    }
    
    var attrLanguage: NSAttributedString {
        .composed(of: [
            "●".styled(with: .color(self.languageColor?.color ?? .random)),
            Special.space,
            Special.space,
            (self.language ?? R.string.localizable.unknown()).styled(with: .color(.title))
        ]).styled(with: .font(.normal(12)))
    }
    
    var attrStars: NSAttributedString {
        .composed(of: [
            R.image.ic_star()!.template.styled(with: .baselineOffset(-2), .color(.title)),
            Special.space,
            self.stars.formatted.styled(with: .color(.title))
        ]).styled(with: .font(.normal(11)))
    }
    
    var attrDesc: NSAttributedString? {
        (self.desc ?? R.string.localizable.noneDesc()).styled(
            with: .font(.normal(15)),
            .lineHeightMultiple(1.1),
            .lineBreakMode(.byTruncatingTail)
        )
    }
    
}
