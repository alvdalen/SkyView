//
//  MappableFromDictionary.swift
//  SkyView
//
//  Created by Adam on 13.02.2026.
//

import Foundation

/// Тип, который можно создать из словаря и опционального идентификатора (для маппинга из JSON/Obj-C).
protocol MappableFromDictionary {
    static func from(_ dict: [String: Any], id: String?) -> Self?
}
