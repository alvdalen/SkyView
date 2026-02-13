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
            tempMin: (dict[kSkyViewKeyTempMin] as? NSNumber)?.doubleValue ?? 0,
            tempMax: (dict[kSkyViewKeyTempMax] as? NSNumber)?.doubleValue ?? 0,
            pressure: (dict[kSkyViewKeyPressure] as? NSNumber)?.intValue ?? 0,
            humidity: (dict[kSkyViewKeyHumidity] as? NSNumber)?.intValue ?? 0,
            visibility: (dict[kSkyViewKeyVisibility] as? NSNumber)?.intValue ?? 0,
            clouds: (dict[kSkyViewKeyClouds] as? NSNumber)?.intValue ?? 0,
            description: (dict[kSkyViewKeyDescription] as? String) ?? "",
            icon: (dict[kSkyViewKeyIcon] as? String) ?? ""
        )
    }
}
