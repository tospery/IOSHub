//
//  User.swift
//  IOSHub
//
//  Created by 杨建祥 on 2020/11/28.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator
import Rswift
import HiIOS
import ReusableKit_Hi
import ObjectMapper_Hi

struct User: Subjective, Eventable {
    
    enum Event {
    }
    
    var id = 0
    var username: String?
    var starredUrl: String?
    var bio: String?
    var blog: String?
    var organizationsUrl: String?
    var gravatarId: String?
    var name: String?
    var following: Int?
    var avatarUrl: String?
    var followers: Int?
    var subscriptionsUrl: String?
    var createdAt: String?
    var nodeId: String?
    var gistsUrl: String?
    var reposUrl: String?
    var company: String?
    var receivedEventsUrl: String?
    var htmlUrl: String?
    var followersUrl: String?
    var siteAdmin: Bool?
    var email: String?
    var twitterUsername: String?
    var type: String?
    var updatedAt: String?
    var url: String?
    var followingUrl: String?
    var hireable: String?
    var publicGists: Int?
    var location: String?
    var eventsUrl: String?
    var publicRepos: Int?
    
    var isValid: Bool {
        id != 0 && username?.isNotEmpty ?? false
    }
    
    var milestone: String { "https://ghchart.rshah.org/1CA035/\(String(describing: username))" }
    
    var joinedOn: String? {
        guard let string = self.createdAt else { return nil }
        guard let date = Date.init(iso8601: string) else { return nil }
        let value = date.string(withFormat: "yyyy-MM-dd")
        return R.string.localizable.joinedOn(value)
    }
    
    init() {
    }

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        id                      <- map["id"]
        username                <- map["login"]
        starredUrl              <- map["starred_url"]
        bio                     <- map["bio"]
        blog                    <- map["blog"]
        organizationsUrl        <- map["organizations_url"]
        gravatarId              <- map["gravatar_id"]
        name                    <- map["name"]
        following               <- map["following"]
        avatarUrl               <- map["avatar_url"]
        followers               <- map["followers"]
        subscriptionsUrl        <- map["subscriptions_url"]
        createdAt               <- map["created_at"]
        nodeId                  <- map["node_id"]
        gistsUrl                <- map["gists_url"]
        reposUrl                <- map["repos_url"]
        company                 <- map["company"]
        receivedEventsUrl       <- map["received_events_url"]
        htmlUrl                 <- map["html_url"]
        followersUrl            <- map["followers_url"]
        siteAdmin               <- map["site_admin"]
        email                   <- map["email"]
        twitterUsername         <- map["twitter_username"]
        type                    <- map["type"]
        updatedAt               <- map["updated_at"]
        url                     <- map["url"]
        followingUrl            <- map["following_url"]
        hireable                <- map["hireable"]
        publicGists             <- map["public_gists"]
        location                <- map["location"]
        eventsUrl               <- map["events_url"]
        publicRepos             <- map["public_repos"]
    }
    
    static func update(_ user: User?, reactive: Bool) {
        let old = Self.current
        let new = user
        if old == new {
            log("相同用户，不需要处理！！！")
            return
        }
        let oldLogined = old?.isValid ?? false
        let newLogined = new?.isValid ?? false
        if !oldLogined && newLogined {
            log("用户登录: \(String(describing: new))")
        } else if oldLogined && !newLogined {
            log("用户退出")
        } else {
            log("用户更新: \(String(describing: new))")
        }
        Subjection.update(self, new, reactive)
//        let userid = new?.id.string
//        if userid != Preference.current?.id {
//            Subjection.update(
//                Preference.self,
//                Preference.cachedObject(id: userid) ?? .init(id: userid ?? ""),
//                true
//            )
//        }
    }
    
}
