//
//  WeatherDetailDayCardView.swift
//  SkyView
//
//  Created by Adam on 15.02.2026.
//

import SwiftUI

/// Одна карточка в блоке "Прогноз на 8 дней": слева - дата/день, описание,
/// бейджи (давление, влажность, облачность), справа - мин/макс температура и иконка.
/// Используется в списке по дням.
struct WeatherDetailDayCardView: View {
    let day: DayForecast
    let dayTitle: String
    let accentColor: Color

    var body: some View {
        HStack(alignment: .center, spacing: LocalConstants.spacingBlock) {
            leftColumn
            Divider()
                .frame(width: LocalConstants.dividerWidth)
            rightColumn
        }
        .padding(LocalConstants.cardPadding)
        .background(
            RoundedRectangle(cornerRadius: LocalConstants.cardRadius, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
        )
    }

    private var dayInfoBlock: some View {
        VStack(alignment: .leading, spacing: LocalConstants.spacingSmall) {
            Text(WeatherDetailHelpers.capitalizedFirst(dayTitle))
                .font(.system(size: LocalConstants.bodyMediumFontSize, weight: .medium))
            Text(WeatherDetailHelpers.capitalizedFirst(day.description))
                .font(.system(size: LocalConstants.captionFontSize))
                .foregroundStyle(.secondary)
        }
        .padding(.leading, LocalConstants.dayCardTextLeadingPadding)
    }

    private var badgesRow: some View {
        HStack(spacing: LocalConstants.spacingContent) {
MiniBadgeView(icon: Asset.Symbols.gaugeMedium, value: "\(day.pressure)", accent: accentColor)
                    MiniBadgeView(icon: Asset.Symbols.humidityFill, value: "\(day.humidity)%", accent: accentColor)
                    MiniBadgeView(icon: Asset.Symbols.cloudFill, value: "\(day.clouds)%", accent: accentColor)
        }
        .padding(.horizontal, LocalConstants.badgeContainerHorizontalPadding)
        .padding(.vertical, LocalConstants.badgeContainerVerticalPadding)
        .background(
            RoundedRectangle(cornerRadius: LocalConstants.innerRadius, style: .continuous)
                .fill(Color(.tertiarySystemGroupedBackground))
        )
    }

    private var leftColumn: some View {
        VStack(alignment: .leading, spacing: LocalConstants.spacingBlock) {
            dayInfoBlock
            badgesRow
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var rightColumn: some View {
        VStack(spacing: LocalConstants.spacingTighter) {
            Text("\(Int(day.tempMin))°   \(Int(day.tempMax))°")
                .font(.system(size: LocalConstants.bodyFontSize, weight: .semibold, design: .rounded))
                .foregroundStyle(.primary)
            Image(systemName: WeatherDetailHelpers.sfSymbol(for: day.icon))
                .font(.system(size: LocalConstants.secondaryIconSize))
                .symbolRenderingMode(.monochrome)
                .foregroundStyle(accentColor)
        }
        .frame(minWidth: LocalConstants.dayCardRightColumnMinWidth, alignment: .center)
    }
}

// MARK: - MiniBadgeView
private struct MiniBadgeView: View {
    let icon: String
    let value: String
    let accent: Color?

    var body: some View {
        HStack(spacing: WeatherDetailDayCardView.LocalConstants.spacingMinimal) {
            Image(systemName: icon)
                .font(.system(size: WeatherDetailDayCardView.LocalConstants.miniIconSize))
            Text(value)
                .font(.system(size: WeatherDetailDayCardView.LocalConstants.smallFontSize))
        }
        .foregroundStyle(accent ?? .secondary)
    }
}

// MARK: - Constants
private extension WeatherDetailDayCardView {
    enum LocalConstants {
        static let spacingBlock: CGFloat = 12
        static let spacingSmall: CGFloat = 8
        static let spacingContent: CGFloat = 16
        static let spacingTighter: CGFloat = 6
        static let cardPadding: CGFloat = 10
        static let cardRadius: CGFloat = 18
        static let minimalPadding: CGFloat = 4
        static var innerRadius: CGFloat { max(minimalPadding, cardRadius - cardPadding) }
        static let dayCardTextLeadingPadding: CGFloat = 4
        static let badgeContainerHorizontalPadding: CGFloat = 12
        static let badgeContainerVerticalPadding: CGFloat = 8
        static let dividerWidth: CGFloat = 1
        static let bodyMediumFontSize: CGFloat = 14
        static let captionFontSize: CGFloat = 13
        static let bodyFontSize: CGFloat = 16
        static let secondaryIconSize: CGFloat = 22
        static let dayCardRightColumnMinWidth: CGFloat = 70
        static let spacingMinimal: CGFloat = 4
        static let miniIconSize: CGFloat = 10
        static let smallFontSize: CGFloat = 12
    }
}
