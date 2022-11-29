//
//  User+Ex.swift
//  IOSHub
//
//  Created by 杨建祥 on 2022/11/29.
//

import Foundation
import BonMot

extension User {
    
    var milestone: String { "https://ghchart.rshah.org/1CA035/\(String(describing: username))" }
    
    var joinedOn: String? {
        guard let string = self.createdAt else { return nil }
        guard let date = Date.init(iso8601: string) else { return nil }
        let value = date.string(withFormat: "yyyy-MM-dd")
        return R.string.localizable.joinedOn(value)
    }
    
    var repositoresText: NSAttributedString {
        self.stat(R.string.localizable.repositores(), self.publicRepos)
    }
    
    var followersText: NSAttributedString {
        self.stat(R.string.localizable.followers(), self.followers)
    }
    
    var followingText: NSAttributedString {
        self.stat(R.string.localizable.following(), self.following)
    }
    
    func text(cellId: CellId) -> String? {
        var result: String?
        switch cellId {
        case .nickname: result = self.nickname
        case .bio: result = self.bio
        case .company: result = self.company
        case .location: result = self.location
        case .blog: result = self.blog
        default: result = nil
        }
        return result ?? R.string.localizable.noDescription()
    }
    
    func stat(_ text: String, _ count: Int) -> NSAttributedString {
        .composed(of: [
            count.string.styled(with: .color(.foreground), .font(.bold(22))),
            Special.nextLine,
            text.styled(with: .color(.body), .font(.normal(13)))
        ]).styled(with: .lineSpacing(4), .alignment(.center))
    }
    
}
