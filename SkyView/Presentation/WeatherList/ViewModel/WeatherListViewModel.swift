//
//  WeatherListViewModel.swift
//  SkyView
//
//  Created by Adam on 14.02.2026.
//

import Combine

@MainActor
final class WeatherListViewModel: ObservableObject {
    // MARK: Private Properties
    @Published private(set) var state: WeatherListState = .initial
    @Published private(set) var refreshingCityId: String? = nil
    @Published private(set) var errorToShow: (message: String, retryContext: RetryContext)?
    private let useCase: LoadAllWeatherUseCase
    
    // MARK: Internal Properties
    var loadedItems: [CityWeather]? {
        if case .loaded(let items) = state { return items }
        return nil
    }
    
    // MARK: Initializers
    init(useCase: LoadAllWeatherUseCase) {
        self.useCase = useCase
    }
    
    // MARK: Internal Methods
    func refresh() async {
        guard !state.isLoading else { return }
        state = .loading

        let outcome = await useCase.execute()
        if outcome.items.isEmpty, let message = outcome.errorMessage {
            state = .loaded([])
            errorToShow = (message, .fullRefresh)
        } else {
            state = .loaded(outcome.items)
        }
    }
    
    func refreshCity(_ cityId: String) async {
        guard refreshingCityId == nil else { return }
        refreshingCityId = cityId
        defer { refreshingCityId = nil }

        do {
            let weather = try await useCase.fetchWeather(cityId: cityId)
            guard case .loaded(var items) = state else { return }
            if let index = items.firstIndex(where: { $0.city.id == cityId }) {
                items[index] = weather
                state = .loaded(items)
            }
        } catch {
            errorToShow = (error.localizedDescription, .refreshCity(cityId))
        }
    }

    func clearError() {
        errorToShow = nil
    }

    func retry() {
        guard let ctx = errorToShow?.retryContext else { return }
        errorToShow = nil
        switch ctx {
        case .fullRefresh:
            Task { await refresh() }
        case .refreshCity(let id):
            Task { await refreshCity(id) }
        }
    }
}

// MARK: - RetryContext
/// Контекст повтора для единого алерта ошибок.
enum RetryContext {
    case fullRefresh
    case refreshCity(String)
}

// MARK: - State
/// Состояния экрана списка погоды: что показывать в контенте (пусто со спиннером или список).
/// `initial`: до первой загрузки.
/// `loading`: идёт запрос.
/// `loaded`: данные есть, показываем список (может быть пустым при ошибке, сама ошибка в `errorToShow`).
enum WeatherListState {
    case initial
    case loading
    case loaded([CityWeather])
}

extension WeatherListState {
    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }
}
