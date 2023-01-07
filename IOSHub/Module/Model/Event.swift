//
//  Event.swift
//  IOSHub
//
//  Created by 杨建祥 on 2023/1/7.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator
import Rswift
import HiIOS
import BonMot
import ReusableKit_Hi
import ObjectMapper_Hi

enum EventType: String, Codable {
    case star = "WatchEvent"
    case fork = "ForkEvent"
    case issueHandle = "IssuesEvent"
    case issueComment = "IssueCommentEvent"
    case commitComment = "CommitCommentEvent"
    case create = "CreateEvent"
    case delete = "DeleteEvent"
    case member = "MemberEvent"
    case organizationBlock = "OrgBlockEvent"
    case `public` = "PublicEvent"
    case pullRequest = "PullRequestEvent"
    case pullRequestReviewComment = "PullRequestReviewCommentEvent"
    case push = "PushEvent"
    case release = "ReleaseEvent"
    case unknown = ""
    
    var title: String? {
        switch self {
        case .star: return R.string.localizable.eventStar()
        case .fork: return R.string.localizable.eventFork()
        case .issueHandle: return R.string.localizable.eventIssueHandle()
        case .issueComment: return R.string.localizable.eventIssueComment()
        default: return nil
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .star: return R.image.ic_event_star()
        case .fork: return R.image.ic_event_fork()
        case .issueHandle: return R.image.ic_event_issue_handle()
        case .issueComment: return R.image.ic_event_issue_comment()
        default: return nil
        }
    }
    
}

struct Event: Subjective, Eventable {
    
    enum Event {
    }
    
    var id = 0
    var type = EventType.unknown
    var actor: BaseUser?
    var repo: BaseRepo?
    var payload: Payload?
    var `public`: Bool?
    var createdAt: String?
    
    var time: String? {
        guard let string = self.createdAt else { return nil }
        guard let date = Date.init(iso8601: string) else { return nil }
        return date.string(withFormat: "yyyy-MM-dd HH:mm")
    }
    
    var content: NSAttributedString? {
        switch self.type {
        case .star:
            return .composed(of: [
                (self.actor?.username ?? R.string.localizable.unknown())
                    .styled(with: .font(.bold(16)), .color(.primary)),
                " \(self.payload?.action ?? "") "
                    .styled(with: .font(.normal(16)), .color(.title)),
                (self.repo?.name ?? R.string.localizable.unknown())
                    .styled(with: .font(.bold(16)), .color(.primary))
            ])
        case .fork:
            return .composed(of: [
                (self.actor?.username ?? R.string.localizable.unknown())
                    .styled(with: .font(.bold(16)), .color(.primary)),
                " \(self.payload?.action ?? R.string.localizable.forked().lowercased()) "
                    .styled(with: .font(.normal(16)), .color(.title)),
                (self.repo?.name ?? R.string.localizable.unknown())
                    .styled(with: .font(.bold(16)), .color(.primary))
            ])
        case .issueHandle, .issueComment:
            return .composed(of: [
                (self.actor?.username ?? R.string.localizable.unknown())
                    .styled(with: .font(.bold(16)), .color(.primary)),
                (" \(self.payload?.action ?? "") \(R.string.localizable.issue()) ")
                    .styled(with: .font(.normal(16)), .color(.title)),
                (self.repo?.name ?? R.string.localizable.unknown())
                    .styled(with: .font(.bold(16)), .color(.primary)),
                Special.nextLine,
                (self.payload?.issue?.title ?? "")
                    .styled(with: .font(.normal(13)), .color(.foreground))
            ])
        default:
            return nil
        }
    }
    
    init() { }

    init?(map: Map) { }

    mutating func mapping(map: Map) {
        id              <- map["id"]
        type            <- map["type"]
        actor           <- map["actor"]
        repo            <- map["repo"]
        payload         <- map["payload"]
        `public`        <- map["public"]
        createdAt       <- map["created_at"]
    }
    
}
