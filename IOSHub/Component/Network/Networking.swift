//
//  Networking.swift
//  IOSHub
//
//  Created by 杨建祥 on 2020/11/28.
//

import Foundation
import Moya
import HiIOS

struct Networking: NetworkingType {

    typealias Target = MultiTarget
    let provider: MoyaProvider<MultiTarget>
    
//    static var stubClosure: MoyaProvider<Target>.StubClosure {
//        return { target in
//            if let tg2 = target.target as? ChargeAPI {
//                switch tg2 {
//                case .accelerate:
//                    return .delayed(seconds: 2)
//                default:
//                    return .never
//                }
//            }
//            return .never
//        }
//    }
    
    static var plugins: [PluginType] {
        var plugins: [PluginType] = []
        let logger = NetworkLoggerPlugin.init()
        logger.configuration.logOptions = [.requestBody, .successResponseBody, .errorResponseBody]
        logger.configuration.output = output
        plugins.append(logger)
        return plugins
    }
    
    static func output(target: TargetType, items: [String]) {
        for item in items {
            log(item, module: .restful)
        }
    }
    
}
