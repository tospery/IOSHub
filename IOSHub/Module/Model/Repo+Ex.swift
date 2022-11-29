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
    
    var languageText: NSAttributedString {
        .composed(of: [
            "●".styled(with: .color(self.languageColor?.color ?? .random)),
            Special.space,
            Special.space,
            (self.language ?? R.string.localizable.unknown()).styled(with: .color(.title))
        ]).styled(with: .font(.normal(12)))
    }
    
}
