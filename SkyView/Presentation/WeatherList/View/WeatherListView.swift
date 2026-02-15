//
//  WeatherListView.swift
//  SkyView
//
//  Created by Adam on 12.02.2026.
//

import SwiftUI

/// Главный экран списка погоды: список городов с ячейками, при тапе - переход в детали,
/// при ошибке - сообщение и кнопка "Повторить". В футере - ссылка на Open Weather Map.
struct WeatherListView: View {
    @StateObject var viewModel: WeatherListViewModel
    
    private var isLoading: Bool {
        viewModel.state.isLoading && (viewModel.loadedItems ?? []).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            stateContent
                .navigationTitle(Localized.weatherTitle)
                .navigationBarTitleDisplayMode(.large)
                .navigationDestination(for: CityWeather.self) { cityWeather in
                    WeatherDetailConfigurator.configure(cityWeather: cityWeather)
                }
        }
        .spinnerOverlay(isLoading: isLoading)
        .errorAlert(
            message: viewModel.errorToShow?.message,
            onRetry: viewModel.errorToShow != nil ? { viewModel.retry() } : nil,
            onDismiss: viewModel.clearError
        )
        .task {
            if (viewModel.loadedItems ?? []).isEmpty {
                await viewModel.refresh()
            }
        }
    }

    /// Контент по состоянию:
    /// `initial/loading` - пусто (спиннер),
    /// `loaded` - список.
    /// Ошибки через`.errorAlert`.
    @ViewBuilder
    private var stateContent: some View {
        switch viewModel.state {
        case .initial, .loading:
            EmptyView()
        case .loaded(let items):
            listContent(items: items)
        }
    }

    private func listContent(items: [CityWeather]) -> some View {
        List {
            Section {
                cityListRows(items: items)
            } footer: {
                sectionFooter
            }
        }
    }

    private func cityListRows(items: [CityWeather]) -> some View {
        ForEach(items) { item in
            NavigationLink(value: item) {
                WeatherCityCell(
                    weather: item,
                    isRefreshing: viewModel.refreshingCityId == item.city.id,
                    onRefresh: {
                        Task { await viewModel.refreshCity(item.city.id) }
                    }
                )
            }
        }
    }

    private var sectionFooter: some View {
        Link(destination: URL(string: "https://openweathermap.org")!) {
            HStack(spacing: LocalConstants.footerHStackSpacing) {
                Text(Localized.openWeatherMapLink)
                Image(systemName: Asset.Symbols.arrowUpRight)
                    .font(.caption2)
            }
            .foregroundStyle(.secondary)
        }
        .font(.caption)
        .tint(.secondary)
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.top, LocalConstants.footerTopPadding)
    }
}

// MARK: - Constants
private extension WeatherListView {
    enum LocalConstants {
        static let footerHStackSpacing: CGFloat = 4
        static let footerTopPadding: CGFloat = 22
    }
}

// MARK: - Preview
#Preview {
    let useCase = LoadAllWeatherUseCaseExecutor(repository: PreviewWeatherRepository())
    let viewModel = WeatherListViewModel(useCase: useCase)
    return WeatherListView(viewModel: viewModel)
}
