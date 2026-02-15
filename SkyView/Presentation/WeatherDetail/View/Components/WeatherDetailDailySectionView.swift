//
//  WeatherDetailDailySectionView.swift
//  SkyView
//
//  Created by Adam on 15.02.2026.
//

import SwiftUI

/// Секция "Прогноз на 8 дней": заголовок с иконкой календаря и список карточек по дням.
/// Принимает массив прогнозов и замыкание для подписи дня (например отформатированная дата).
struct WeatherDetailDailySectionView: View {
    let dailyForecast: [DayForecast]
    let dayTitle: (DayForecast) -> String

    var body: some View {
        VStack(alignment: .leading, spacing: LocalConstants.spacingContent) {
            VStack(alignment: .leading, spacing: LocalConstants.spacingSmall) {
                HStack(spacing: LocalConstants.spacingSmall) {
                    Image(systemName: "calendar")
                        .font(.system(size: LocalConstants.sectionIconSize))
                        .foregroundStyle(.secondary)
                    sectionLabel("Прогноз на 8 дней")
                }
                .padding(.leading, LocalConstants.sectionContentLeading)
                Divider()
                    .padding(.horizontal, LocalConstants.sectionContentLeading)
            }
            ForEach(dailyForecast) { day in
                WeatherDetailDayCardView(
                    day: day,
                    dayTitle: dayTitle(day),
                    accentColor: day.tempMax < 10 ? Color.blue : Color.orange
                )
            }
        }
    }

    private func sectionLabel(_ text: String) -> some View {
        Text(text)
            .font(.system(size: LocalConstants.smallFontSize, weight: .semibold))
            .foregroundStyle(.secondary)
    }
}

// MARK: - Constants
private extension WeatherDetailDailySectionView {
    enum LocalConstants {
        static let spacingContent: CGFloat = 16
        static let spacingSmall: CGFloat = 8
        static let sectionContentLeading: CGFloat = 10
        static let sectionIconSize: CGFloat = 12
        static let smallFontSize: CGFloat = 12
    }
}
