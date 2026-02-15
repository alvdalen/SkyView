//
//  WeatherListViewModelTests.swift
//  SkyViewTests
//
//  Created by Adam on 16.02.2026.
//

import XCTest
@testable import SkyView

@MainActor
final class WeatherListViewModelTests: XCTestCase {
    private var sut: WeatherListViewModel!
    private var mockRepository: MockWeatherFetching!

    override func setUp() {
        super.setUp()
        mockRepository = MockWeatherFetching()
        let useCase = LoadAllWeatherUseCaseExecutor(repository: mockRepository)
        sut = WeatherListViewModel(useCase: useCase)
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }

    // Успех обновления списка
    func testRefresh_whenExecuteReturnsItems_stateIsLoadedAndNoError() async {
        await sut.refresh()

        XCTAssertEqual(sut.loadedItems?.count, CapitalsProvider.list.count)
        XCTAssertNil(sut.errorToShow)
        if case .loaded = sut.state { } else {
            XCTFail("Expected state .loaded")
        }
    }

    // Ошибка обновления: пустой список и сообщение об ошибке
    func testRefresh_whenExecuteReturnsEmptyAndErrorMessage_stateIsLoadedEmptyAndErrorToShow() async {
        mockRepository.fetchAllOverride = [
            .failure(NSError(domain: "Test", code: -1, userInfo: [NSLocalizedDescriptionKey: "Network error"]))
        ]

        await sut.refresh()

        if case .loaded(let list) = sut.state {
            XCTAssertTrue(list.isEmpty)
        } else {
            XCTFail("Expected state .loaded([])")
        }
        XCTAssertEqual(sut.errorToShow?.message, "Network error")
        if case .fullRefresh? = sut.errorToShow?.retryContext { } else {
            XCTFail("Expected retryContext .fullRefresh")
        }
    }

    // Успешное обновление погоды по одному городу
    func testRefreshCity_whenFetchSucceeds_updatesCityInList() async {
        await sut.refresh()

        await sut.refreshCity("london")

        let london = sut.loadedItems?.first { $0.city.id == "london" }
        XCTAssertNotNil(london)
        XCTAssertEqual(london?.current.temperature, 12)
        XCTAssertNil(sut.errorToShow)
    }

    // Ошибка при обновлении погоды по городу
    func testRefreshCity_whenFetchThrows_setsErrorToShowWithRefreshCityContext() async {
        await sut.refresh()

        mockRepository.fetchWeatherOverride = .failure(
            NSError(domain: "Test", code: -1, userInfo: [NSLocalizedDescriptionKey: "TLS error"])
        )

        await sut.refreshCity("london")

        XCTAssertEqual(sut.errorToShow?.message, "TLS error")
        if case .refreshCity(let id)? = sut.errorToShow?.retryContext {
            XCTAssertEqual(id, "london")
        } else {
            XCTFail("Expected retryContext .refreshCity(\"london\")")
        }
    }

    // Кнопка Повторить в алерте при ошибке полного обновления
    func testRetry_whenContextIsFullRefresh_callsRefresh() async {
        mockRepository.fetchAllOverride = [
            .failure(NSError(domain: "Test", code: 0, userInfo: [NSLocalizedDescriptionKey: "Fail"]))
        ]
        await sut.refresh()
        XCTAssertNotNil(sut.errorToShow)

        mockRepository.fetchAllOverride = nil

        sut.retry()

        await Task.yield()
        await Task.yield()

        XCTAssertEqual(sut.loadedItems?.count, CapitalsProvider.list.count)
    }

    // Кнопка Повторить в алерте при ошибке обновления города
    func testRetry_whenContextIsRefreshCity_callsRefreshCity() async {
        await sut.refresh()

        mockRepository.fetchWeatherOverride = .failure(NSError(domain: "Test", code: 0, userInfo: nil))
        await sut.refreshCity("london")
        XCTAssertNotNil(sut.errorToShow)

        mockRepository.fetchWeatherOverride = nil

        sut.retry()

        await Task.yield()
        await Task.yield()

        let london = sut.loadedItems?.first { $0.city.id == "london" }
        XCTAssertEqual(london?.current.temperature, 12)
    }

    // Закрытие алерта, сброс ошибки
    func testClearError_clearsErrorToShow() async {
        mockRepository.fetchAllOverride = [
            .failure(NSError(domain: "Test", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error"]))
        ]
        await sut.refresh()
        XCTAssertNotNil(sut.errorToShow)

        sut.clearError()

        XCTAssertNil(sut.errorToShow)
    }

    // Защита от повторного вызова при уже идущей загрузке
    func testRefresh_whenAlreadyLoading_doesNothing() async {
        mockRepository.fetchAllDelayNanoseconds = 50_000_000

        let firstTask = Task { await sut.refresh() }
        await sut.refresh()
        await firstTask.value

        XCTAssertEqual(sut.loadedItems?.count, CapitalsProvider.list.count)
    }

    // Защита от повторного обновления города при уже идущем обновлении
    func testRefreshCity_whenAlreadyRefreshing_doesNothing() async {
        mockRepository.fetchWeatherDelayNanoseconds = 50_000_000
        await sut.refresh()

        let firstTask = Task { await sut.refreshCity("london") }
        await sut.refreshCity("london")
        await firstTask.value

        let london = sut.loadedItems?.first { $0.city.id == "london" }
        XCTAssertEqual(london?.current.temperature, 12)
    }
}
