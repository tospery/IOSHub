//
//  User+Ex.swift
//  IOSHub
//
//  Created by 杨建祥 on 2022/11/29.
//

import Foundation
import BonMot

extension User {

    var isOrganization: Bool { self.type == "Organization" }
    
    var milestone: String { "https://ghchart.rshah.org/1CA035/\(String(describing: username))" }
    
    var joinedOn: String? {
        guard let string = self.createdAt else { return nil }
        guard let date = Date.init(iso8601: string) else { return nil }
        let value = date.string(withFormat: "yyyy-MM-dd")
        return R.string.localizable.joinedOn(value)
    }
    
    var infoAttributedText: NSAttributedString {
        .composed(of: [
            self.locationAttributedText
                .styled(with: .color(.title)),
            Special.nextLine,
            (self.joinedOn ?? R.string.localizable.unknown())
                .styled(with: .font(.normal(12)), .color(.body))
        ])
    }
    
    var locationAttributedText: NSAttributedString {
        .composed(of: [
            R.image.ic_location()!.template
                .styled(with: .baselineOffset(-2), .font(.normal(10))),
            Special.space,
            (self.location ?? R.string.localizable.noneLocation())
                .styled(with: .font(.normal(13)))
        ]).styled(with: .color(.foreground))
    }
    
    var repoAttributedText: NSAttributedString {
        .composed(of: [
            R.image.ic_repo_small()!
                .styled(with: .baselineOffset(-4)),
            Special.space,
            (self.repo?.name ?? R.string.localizable.noneRepo())
                .attributedString()
        ]).styled(with: .color(.title), .font(.normal(14)))
    }
    
    var fullnameAttributedText: NSAttributedString {
        .composed(of: [
            (self.nickname ?? R.string.localizable.unknown())
                .styled(with: .color(.primary)),
            Special.space,
            "(\(self.username ?? R.string.localizable.unknown()))"
                .styled(with: .color(.title))
        ]).styled(with: .font(.bold(16)))
    }
    
//    var attrFullname: NSAttributedString {
//        .composed(of: [
//            (self.username ?? R.string.localizable.unknown()).attributedString(),
//            Special.space,
//            "(\(self.nickname ?? R.string.localizable.unknown()))".attributedString()
//        ]).styled(with: .color(.title), .font(.normal(17)))
//    }
//    
//    var attrRepoName: NSAttributedString {
//        NSAttributedString.composed(of: [
//            R.image.ic_repo_small()!.styled(with: .baselineOffset(-4)),
//            Special.space,
//            (self.repo?.name ?? R.string.localizable.noneRepo()).attributedString()
//        ]).styled(with: .color(.primary), .font(.normal(14)))
//    }
//    
//    var repoDesc: String {
//        self.repo?.desc ?? R.string.localizable.noneDesc()
//    }
    
    var attrRepositores: NSAttributedString {
        self.attr(R.string.localizable.repositores(), self.publicRepos)
    }
    
    var attrFollowers: NSAttributedString {
        self.attr(R.string.localizable.followers(), self.followers)
    }
    
    var attrfollowing: NSAttributedString {
        self.attr(R.string.localizable.following(), self.following)
    }
    
    func text(cellId: CellId) -> String? {
        var result: String?
        switch cellId {
        case .nickname: result = self.nickname
        case .bio: result = self.bio
        case .company: result = self.company?.isEmpty ?? true ? R.string.localizable.noneCompany() : self.company
        case .location: result = self.location?.isEmpty ?? true ? R.string.localizable.noneLocation() : self.location
        case .email: result = self.email?.isEmpty ?? true ? R.string.localizable.noneEmail() : self.email
        case .blog: result = self.blog?.isEmpty ?? true ? R.string.localizable.noneBlog() : self.blog
        default: result = nil
        }
        return result
    }
    
    func attr(_ text: String, _ count: Int) -> NSAttributedString {
        .composed(of: [
            count.string.styled(with: .color(.foreground), .font(.bold(22))),
            Special.nextLine,
            text.styled(with: .color(.body), .font(.normal(13)))
        ]).styled(with: .lineSpacing(4), .alignment(.center))
    }
    
    mutating func setup(displayMode: DisplayMode) {
        var repo = self
        repo.displayMode = displayMode
        self = repo
    }
    
}
