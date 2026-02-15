//
//  DayForecast+Mapping.swift
//  SkyView
//
//  Created by Adam on 13.02.2026.
//

import Foundation

extension DayForecast: MappableFromDictionary {
    static func from(_ dict: [String: Any], id: String?) -> DayForecast? {
        guard let id = id, let dtNum = dict[kSkyViewKeyDt] as? NSNumber else { return nil }
        let date = Date(timeIntervalSince1970: dtNum.doubleValue)
        return DayForecast(
            id: id,
            date: date,
            tempMin: (dict[kSkyViewKeyTempMin] as? NSNumber)?.doubleValue ?? .zero,
            tempMax: (dict[kSkyViewKeyTempMax] as? NSNumber)?.doubleValue ?? .zero,
            pressure: (dict[kSkyViewKeyPressure] as? NSNumber)?.intValue ?? .zero,
            humidity: (dict[kSkyViewKeyHumidity] as? NSNumber)?.intValue ?? .zero,
            visibility: (dict[kSkyViewKeyVisibility] as? NSNumber)?.intValue ?? .zero,
            clouds: (dict[kSkyViewKeyClouds] as? NSNumber)?.intValue ?? .zero,
            description: (dict[kSkyViewKeyDescription] as? String) ?? "",
            icon: (dict[kSkyViewKeyIcon] as? String) ?? ""
        )
    }
}
