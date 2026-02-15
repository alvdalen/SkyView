//
//  WeatherDetailHelpers.swift
//  SkyView
//
//  Created by Adam on 15.02.2026.
//

import Foundation

/// Вспомогательные функции для экрана детали погоды: форматирование строк (первая буква заглавная),
/// чисел, видимости в метрах/км и маппинг кода иконки `OpenWeather` в `SF Symbol`.
enum WeatherDetailHelpers {
    static func capitalizedFirst(_ string: String) -> String {
        guard let first = string.first else { return string }
        return first.uppercased() + string.dropFirst().lowercased()
    }

    static func formatDouble(_ v: Double) -> String {
        let n = Int(v)
        return n == Int(v * 10) / 10 ? "\(n)" : String(format: "%.1f", v)
    }

    static func visibilityString(_ meters: Int) -> String {
        if meters >= 10000 { return "10+ км" }
        if meters >= 1000 { return String(format: "%.1f км", Double(meters) / 1000) }
        return "\(meters) м"
    }

    static func sfSymbol(for icon: String) -> String {
        let code = icon.filter(\.isNumber)
        let isNight = icon.hasSuffix("n")
        switch code {
        case "01": return isNight ? "moon.stars.fill" : "sun.max.fill"
        case "02", "03", "04", "2": return isNight ? "cloud.moon.fill" : "cloud.sun.fill"
        case "09", "10": return "cloud.rain.fill"
        case "11": return "cloud.bolt.fill"
        case "13": return "snowflake"
        case "50": return "water.waves"
        default: return "cloud.fill"
        }
    }
}
