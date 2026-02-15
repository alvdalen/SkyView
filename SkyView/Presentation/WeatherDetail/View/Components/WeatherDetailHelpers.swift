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
    /// Делает первую букву строки заглавной, остальные - строчными. Пустую строку возвращает без изменений.
    static func capitalizedFirst(_ string: String) -> String {
        guard let first = string.first else { return string }
        return first.uppercased() + string.dropFirst().lowercased()
    }

    /// Форматирует число: без дробной части, если дробная равна нулю, иначе один знак после запятой.
    static func formatDouble(_ v: Double) -> String {
        let n = Int(v)
        return n == Int(v * 10) / 10 ? "\(n)" : String(format: "%.1f", v)
    }

    /// Переводит видимость из метров в строку: "10+ км".
    static func visibilityString(_ meters: Int) -> String {
        if meters >= 10000 { return Localized.visibilityKm10Plus }
        if meters >= 1000 {
            return String(format: Localized.visibilityKmFormat, Double(meters) / 1000)
        }
        return "\(meters) \(Localized.visibilityM)"
    }

    /// По коду иконки `OpenWeather` (например "01d", "10n") возвращает имя `SF Symbol` для отображения.
    static func sfSymbol(for icon: String) -> String {
        let code = icon.filter(\.isNumber)
        let isNight = icon.hasSuffix("n")
        switch code {
        case "01": return isNight ? Asset.Symbols.moonStarsFill : Asset.Symbols.sunMaxFill
        case "02", "03", "04", "2": return isNight ? Asset.Symbols.cloudMoonFill : Asset.Symbols.cloudSunFill
        case "09", "10": return Asset.Symbols.cloudRainFill
        case "11": return Asset.Symbols.cloudBoltFill
        case "13": return Asset.Symbols.snowflake
        case "50": return Asset.Symbols.waterWaves
        default: return Asset.Symbols.cloudFill
        }
    }
}
