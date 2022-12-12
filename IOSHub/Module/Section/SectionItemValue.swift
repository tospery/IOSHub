//
//  SectionItemValue.swift
//  IOSHub
//
//  Created by 杨建祥 on 2022/10/3.
//

import Foundation

enum SectionItemValue {
    case appInfo
    // case milestone
    case searchOptions
}

extension SectionItemValue: CustomStringConvertible {
    var description: String {
        switch self {
        case .appInfo: return "appInfo"
        case .searchOptions: return "searchOptions"
        }
    }
}
