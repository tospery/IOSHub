//
//  TrendingAPI.swift
//  IOSHub
//
//  Created by 杨建祥 on 2022/11/30.
//

import Foundation
import Moya
import SwifterSwift_Hi
import HiIOS

enum TrendingAPI {
    case languages
    case developers(language: Language?, since: Since?)
    case repositories(language: Language?, since: Since?)
}

extension TrendingAPI: TargetType {

    var baseURL: URL {
        return UIApplication.shared.baseTrendingUrl.url!
    }

    var path: String {
        switch self {
        case .languages: return "/languages"
        case .developers: return "/developers"
        case .repositories: return "/repositories"
        }
    }

    var method: Moya.Method { .get }

    var headers: [String: String]? { nil }

    var task: Task {
        var parameters = envParameters
        let encoding: ParameterEncoding = URLEncoding.default
        switch self {
        case .developers(let language, let since),
             .repositories(let language, let since):
            parameters[Parameter.language] = language?.urlParam
            parameters[Parameter.since] = since?.rawValue
        default:
            break
        }
        return .requestParameters(parameters: parameters, encoding: encoding)
    }

    var validationType: ValidationType { .none }

    var sampleData: Data { Data.init() }

}
