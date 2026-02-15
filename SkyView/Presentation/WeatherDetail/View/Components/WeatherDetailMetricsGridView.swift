//
//  WeatherDetailMetricsGridView.swift
//  SkyView
//
//  Created by Adam on 15.02.2026.
//

import SwiftUI

/// Сетка из шести плиток с текущими метриками: ветер, ощущается, влажность,
/// давление, видимость, облачность. Данные берёт из `TodayWeather`, цвет иконок - из переданного accentColor.
struct WeatherDetailMetricsGridView: View {
    let current: TodayWeather
    let accentColor: Color

    var body: some View {
        let spacing = LocalConstants.spacingBlock
        let columns = [
            GridItem(
                .flexible(),
                spacing: spacing),
            GridItem(
                .flexible(),
                spacing: spacing),
            GridItem(
                .flexible(),
                spacing: spacing)
        ]
        
        return LazyVGrid(columns: columns, spacing: spacing) {
            MetricTileView(
                icon: Asset.Symbols.wind,
                label: Localized.metricWind,
                value: "\(WeatherDetailHelpers.formatDouble(current.windSpeed)) \(Localized.unitWindSpeed)",
                accentColor: accentColor)
            
            MetricTileView(
                icon: Asset.Symbols.thermometerMedium,
                label: Localized.metricFeelsLike,
                value: "\(Int(current.feelsLike))°",
                accentColor: accentColor)
            
            MetricTileView(
                icon: Asset.Symbols.humidityFill,
                label: Localized.metricHumidity,
                value: "\(current.humidity)%",
                accentColor: accentColor)
            
            MetricTileView(
                icon: Asset.Symbols.gaugeMedium,
                label: Localized.metricPressure,
                value: "\(current.pressure) \(Localized.unitPressure)",
                accentColor: accentColor)
            
            MetricTileView(
                icon: Asset.Symbols.eye,
                label: Localized.metricVisibility,
                value: WeatherDetailHelpers.visibilityString(current.visibility),
                accentColor: accentColor)
            
            MetricTileView(
                icon: Asset.Symbols.cloudFill,
                label: Localized.metricClouds,
                value: "\(current.clouds)%",
                accentColor: accentColor)
        }
    }
}

// MARK: - MetricTileView
private struct MetricTileView: View {
    let icon: String
    let label: String
    let value: String
    let accentColor: Color

    var body: some View {
        VStack(spacing: WeatherDetailMetricsGridView.LocalConstants.spacingTight) {
            Image(systemName: icon)
                .font(.system(size: WeatherDetailMetricsGridView.LocalConstants.secondaryIconSize))
                .foregroundStyle(accentColor)
            Text(label)
                .font(.system(size: WeatherDetailMetricsGridView.LocalConstants.metricLabelFontSize))
                .foregroundStyle(.secondary)
                .lineLimit(WeatherDetailMetricsGridView.LocalConstants.metricTileLineLimit)
                .minimumScaleFactor(WeatherDetailMetricsGridView.LocalConstants.minimumScaleFactor)
            Text(value)
                .font(.system(size: WeatherDetailMetricsGridView.LocalConstants.bodyMediumFontSize, weight: .medium, design: .rounded))
                .foregroundStyle(.primary)
                .lineLimit(WeatherDetailMetricsGridView.LocalConstants.metricTileLineLimit)
                .minimumScaleFactor(WeatherDetailMetricsGridView.LocalConstants.minimumScaleFactor)
        }
        .frame(maxWidth: .infinity)
        .aspectRatio(WeatherDetailMetricsGridView.LocalConstants.metricTileAspectRatio, contentMode: .fill)
        .padding(WeatherDetailMetricsGridView.LocalConstants.metricTilePadding)
        .background(
            RoundedRectangle(cornerRadius: WeatherDetailMetricsGridView.LocalConstants.cardRadius, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
        )
    }
}

// MARK: - Constants
private extension WeatherDetailMetricsGridView {
    enum LocalConstants {
        static let spacingBlock: CGFloat = 12
        static let spacingTight: CGFloat = 10
        static let metricTilePadding: CGFloat = 14
        static let cardRadius: CGFloat = 18
        static let metricTileLineLimit: Int = 1
        static let metricTileAspectRatio: CGFloat = 1
        static let secondaryIconSize: CGFloat = 22
        static let metricLabelFontSize: CGFloat = 11
        static let bodyMediumFontSize: CGFloat = 14
        static let minimumScaleFactor: CGFloat = 0.8
    }
}
