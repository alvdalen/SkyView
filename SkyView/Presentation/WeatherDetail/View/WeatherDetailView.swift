//
//  WeatherDetailView.swift
//  SkyView
//
//  Created by Adam on 14.02.2026.
//

import SwiftUI

/// Главный экран детали погоды по выбранному городу: шапка с температурой и иконкой,
/// сетка метрик (ветер, влажность и т.д.), блок "Прогноз на 8 дней".
/// Собирает дочерние вью и передаёт им данные из ViewModel.
struct WeatherDetailView: View {
    @StateObject var viewModel: WeatherDetailViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: LocalConstants.spacingContent) {
                WeatherDetailHeaderView(
                    cityName: viewModel.cityDisplayName,
                    temperature: viewModel.current.temperature,
                    icon: viewModel.current.icon,
                    description: viewModel.current.description,
                    accentColor: accentColor
                )
                Divider()
                    .padding(.horizontal, LocalConstants.screenHorizontalPadding)
                WeatherDetailMetricsGridView(current: viewModel.current, accentColor: accentColor)
                    .padding(.horizontal, LocalConstants.gridHorizontalInset)
                WeatherDetailDailySectionView(dailyForecast: viewModel.dailyForecast, dayTitle: viewModel.dayTitle(for:))
                    .padding(.horizontal, LocalConstants.dailySectionHorizontalInset)
            }
            .padding(.horizontal, LocalConstants.screenHorizontalPadding)
            .padding(.top, .zero)
            .padding(.bottom, LocalConstants.scrollBottomPadding)
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
    }

    private var accentColor: Color {
        viewModel.current.temperature < LocalConstants.coldTemperatureThreshold ? Color.blue : Color.orange
    }
}

// MARK: - Constants
private extension WeatherDetailView {
    enum LocalConstants {
        static let coldTemperatureThreshold: Double = 10
        static let screenHorizontalPadding: CGFloat = 20
        static let scrollBottomPadding: CGFloat = 32
        static let spacingContent: CGFloat = 16
        static let gridHorizontalInset: CGFloat = 10
        static let dailySectionHorizontalInset: CGFloat = -4
    }
}
