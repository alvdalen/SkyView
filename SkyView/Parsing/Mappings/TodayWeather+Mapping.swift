//
//  TodayWeather+Mapping.swift
//  SkyView
//
//  Created by Adam on 13.02.2026.
//

import Foundation

extension TodayWeather: MappableFromDictionary {
    static func from(_ dict: [String: Any], id: String?) -> TodayWeather? {
        guard let dtNum = dict[kSkyViewKeyDt] as? NSNumber else { return nil }
        let updatedAt = Date(timeIntervalSince1970: dtNum.doubleValue)
        return TodayWeather(
            temperature: (dict[kSkyViewKeyTemp] as? NSNumber)?.doubleValue ?? .zero,
            feelsLike: (dict[kSkyViewKeyFeelsLike] as? NSNumber)?.doubleValue ?? .zero,
            humidity: (dict[kSkyViewKeyHumidity] as? NSNumber)?.intValue ?? .zero,
            pressure: (dict[kSkyViewKeyPressure] as? NSNumber)?.intValue ?? .zero,
            windSpeed: (dict[kSkyViewKeyWindSpeed] as? NSNumber)?.doubleValue ?? .zero,
            visibility: (dict[kSkyViewKeyVisibility] as? NSNumber)?.intValue ?? .zero,
            clouds: (dict[kSkyViewKeyClouds] as? NSNumber)?.intValue ?? .zero,
            description: (dict[kSkyViewKeyDescription] as? String) ?? "",
            icon: (dict[kSkyViewKeyIcon] as? String) ?? "",
            updatedAt: updatedAt
        )
    }
}
