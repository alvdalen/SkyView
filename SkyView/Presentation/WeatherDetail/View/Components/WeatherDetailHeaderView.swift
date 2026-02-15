//
//  WeatherDetailHeaderView.swift
//  SkyView
//
//  Created by Adam on 15.02.2026.
//

import SwiftUI

/// Верхний блок экрана детали: название города, текущая температура,
/// большая иконка погоды и краткое описание (например "пасмурно").
/// Цвет иконки задаётся снаружи (`accentColor`).
struct WeatherDetailHeaderView: View {
    let cityName: String
    let temperature: Double
    let icon: String
    let description: String
    let accentColor: Color

    var body: some View {
        VStack(spacing: LocalConstants.spacingBlock) {
            HStack(spacing: LocalConstants.spacingTight) {
                Text(WeatherDetailHelpers.capitalizedFirst(cityName))
                    .font(.system(size: LocalConstants.titleFontSize, weight: .regular))
                    .foregroundStyle(.primary)
                HStack(spacing: LocalConstants.spacingTighter) {
                    Image(systemName: Asset.Symbols.thermometerMedium)
                        .font(.system(size: LocalConstants.mediumIconSize))
                        .foregroundStyle(.primary)
                    Text("\(Int(temperature))°")
                        .font(.system(size: LocalConstants.titleFontSize, weight: .medium, design: .rounded))
                        .monospacedDigit()
                        .foregroundStyle(.primary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            Image(systemName: WeatherDetailHelpers.sfSymbol(for: icon))
                .font(.system(size: LocalConstants.largeIconSize))
                .symbolRenderingMode(.monochrome)
                .foregroundStyle(accentColor)
            Text(WeatherDetailHelpers.capitalizedFirst(description))
                .font(.system(size: LocalConstants.subtitleFontSize))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, LocalConstants.headerTopPadding)
    }
}

// MARK: - Constants
private extension WeatherDetailHeaderView {
    enum LocalConstants {
        static let spacingBlock: CGFloat = 12
        static let spacingTight: CGFloat = 10
        static let spacingTighter: CGFloat = 6
        static let titleFontSize: CGFloat = 32
        static let mediumIconSize: CGFloat = 28
        static let largeIconSize: CGFloat = 47
        static let subtitleFontSize: CGFloat = 20
        static let headerTopPadding: CGFloat = 8
    }
}
