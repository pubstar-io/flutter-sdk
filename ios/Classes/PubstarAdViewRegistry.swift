//
//  PubstarAdViewRegistry.swift
//  pubstar_io
//
//  Created by Mobile  on 13/6/25.
//

import Foundation

class PubstarAdViewRegistry {
    static var shared = PubstarAdViewRegistry()
    
    private init() {}

    var views: [Int64: UIView] = [:]
}
