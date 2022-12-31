//
//  SectionItemValue.swift
//  IOSHub
//
//  Created by 杨建祥 on 2022/10/3.
//

import Foundation

enum SectionItemValue {
    case appInfo
    case milestone
    case searchOptions
    case searchKeywords
}

extension SectionItemValue: CustomStringConvertible {
    var description: String {
        switch self {
        case .appInfo: return "appInfo"
        case .milestone: return "milestone"
        case .searchOptions: return "searchOptions"
        case .searchKeywords: return "searchKeywords"
        }
    }
}
