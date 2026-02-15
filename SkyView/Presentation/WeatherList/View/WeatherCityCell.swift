//
//  WeatherCityCell.swift
//  SkyView
//
//  Created by Adam on 14.02.2026.
//

import SwiftUI

/// Ячейка списка городов: слева - цветная полоска и блок с городом,
/// описанием погоды и бейджами (давление, влажность, облачность),
/// справа - температура, иконка погоды и кнопка обновления.
struct WeatherCityCell: View {
    let weather: CityWeather
    let isRefreshing: Bool
    let onRefresh: () -> Void
    private var isCold: Bool {
        weather.current.temperature < LocalConstants.coldTemperatureThreshold
    }
    
    private var accentColor: Color {
        isCold ? Color.blue : Color.orange
    }
    
    var body: some View {
        HStack(spacing: LocalConstants.mainHStackSpacing) {
            accentBar
            leftColumn
            Spacer(minLength: LocalConstants.spacerMinLength)
            tempBlock
            refreshButton
        }
        .padding(.vertical, LocalConstants.verticalPadding)
        .frame(height: LocalConstants.cellHeight)
    }
    
    private var accentBar: some View {
        RoundedRectangle(cornerRadius: LocalConstants.accentBarCornerRadius)
            .fill(accentColor)
            .frame(width: LocalConstants.accentBarWidth)
    }
    
    private var cityRow: some View {
        HStack(spacing: LocalConstants.cityRowSpacing) {
            Image(systemName: Asset.Symbols.mappin)
                .font(.system(size: LocalConstants.pinIconSize, weight: .semibold))
                .foregroundStyle(accentColor)
            Text(capitalizedFirst(weather.city.name))
                .font(.system(size: LocalConstants.cityNameFontSize, weight: .semibold))
                .lineLimit(LocalConstants.lineLimitSingle)
        }
    }
    
    private var badgesRow: some View {
        HStack(spacing: LocalConstants.badgesSpacing) {
            miniBadge(icon: Asset.Symbols.gaugeMedium, value: "\(weather.current.pressure)")
            miniBadge(icon: Asset.Symbols.humidityFill, value: "\(weather.current.humidity)%")
            miniBadge(icon: Asset.Symbols.cloudFill, value: "\(weather.current.clouds)%")
        }
    }
    
    private var leftColumn: some View {
        VStack(alignment: .leading, spacing: LocalConstants.leftVStackSpacing) {
            cityRow
            Text(capitalizedFirst(weather.current.description))
                .font(.system(size: LocalConstants.descriptionFontSize))
                .foregroundStyle(.secondary)
                .lineLimit(LocalConstants.lineLimitSingle)
                .minimumScaleFactor(LocalConstants.descriptionMinimumScale)
            badgesRow
        }
    }
    
    private var tempBlock: some View {
        HStack(spacing: LocalConstants.tempBlockSpacing) {
            Text("\(Int(weather.current.temperature))°")
                .font(.system(size: LocalConstants.tempFontSize, weight: .regular, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(.primary)
            Image(systemName: iconName(for: weather.current.icon))
                .font(.system(size: LocalConstants.weatherIconSize))
                .symbolRenderingMode(.monochrome)
                .foregroundStyle(accentColor)
                .frame(width: LocalConstants.weatherIconFrameWidth)
        }
    }
    
    private var refreshButton: some View {
        Button {
            onRefresh()
        } label: {
            if isRefreshing {
                ProgressView()
                    .controlSize(.small)
                    .frame(width: LocalConstants.refreshButtonFrameSize, height: LocalConstants.refreshButtonFrameSize)
            } else {
                Image(systemName: Asset.Symbols.arrowClockwise)
                    .font(.system(size: LocalConstants.refreshIconSize))
                    .foregroundStyle(.secondary)
                    .frame(width: LocalConstants.refreshButtonFrameSize, height: LocalConstants.refreshButtonFrameSize)
            }
        }
        .buttonStyle(.plain)
        .disabled(isRefreshing)
    }
    
    private func miniBadge(icon: String, value: String) -> some View {
        HStack(spacing: LocalConstants.miniBadgeSpacing) {
            Image(systemName: icon)
                .font(.system(size: LocalConstants.miniBadgeIconSize))
            Text(value)
                .font(.system(size: LocalConstants.miniBadgeValueFontSize))
        }
        .foregroundStyle(.secondary)
    }
    
    private func capitalizedFirst(_ string: String) -> String {
        guard let first = string.first else { return string }
        return first.uppercased() + string.dropFirst().lowercased()
    }
    
    private func iconName(for icon: String) -> String {
        let isNight = icon.hasSuffix("n")
        if icon.contains("01") { return isNight ? Asset.Symbols.moonStarsFill : Asset.Symbols.sunMaxFill }
        if icon.contains("02") || icon.hasPrefix("2") { return isNight ? Asset.Symbols.cloudMoonFill : Asset.Symbols.cloudSunFill }
        if icon.contains("03") || icon.contains("04") { return isNight ? Asset.Symbols.cloudMoonFill : Asset.Symbols.cloudSunFill }
        if icon.contains("09") || icon.contains("10") { return Asset.Symbols.cloudRainFill }
        if icon.contains("11") { return Asset.Symbols.cloudBoltFill }
        if icon.contains("13") { return Asset.Symbols.snowflake }
        if icon.contains("50") { return Asset.Symbols.waterWaves }
        return Asset.Symbols.cloudFill
    }
}

// MARK: - Constants
private extension WeatherCityCell {
    enum LocalConstants {
        // Основной контейнер ячейки: отступы между блоками, вертикальный padding, высота
        static let mainHStackSpacing: CGFloat = 12
        static let verticalPadding: CGFloat = 4
        static let cellHeight: CGFloat = 76

        // Порог температуры для синего/оранжевого акцента (°C)
        static let coldTemperatureThreshold: Double = 10

        // Цветная полоска слева (акцент по температуре)
        static let accentBarCornerRadius: CGFloat = 1.5
        static let accentBarWidth: CGFloat = 4

        // Левая колонка: отступы, строка с городом (иконка pin и название), одна строка текста
        static let lineLimitSingle: Int = 1
        static let leftVStackSpacing: CGFloat = 8
        static let cityRowSpacing: CGFloat = 4
        static let pinIconSize: CGFloat = 13
        static let cityNameFontSize: CGFloat = 17

        // Описание погоды (одна строка, сжимается при нехватке места)
        static let descriptionFontSize: CGFloat = 14
        static let descriptionMinimumScale: CGFloat = 0.65

        // Ряд бейджей: давление, влажность, облачность
        static let badgesSpacing: CGFloat = 12

        // Блок справа: отступ до температуры, температура и иконка погоды
        static let spacerMinLength: CGFloat = 8
        static let tempBlockSpacing: CGFloat = 8
        static let tempFontSize: CGFloat = 20
        static let weatherIconSize: CGFloat = 20
        static let weatherIconFrameWidth: CGFloat = 26

        // Кнопка обновления (спиннер или стрелка)
        static let refreshButtonFrameSize: CGFloat = 24
        static let refreshIconSize: CGFloat = 13

        // Мини-бейдж: иконка и значение в одну строку
        static let miniBadgeSpacing: CGFloat = 4
        static let miniBadgeIconSize: CGFloat = 10
        static let miniBadgeValueFontSize: CGFloat = 12
    }
}
