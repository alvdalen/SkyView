//
//  WeatherParserTests.swift
//  SkyViewTests
//
//  Created by Adam on 16.02.2026.
//

import XCTest
@testable import SkyView

final class WeatherParserTests: XCTestCase {
    private var sut: WeatherParser!
    
    override func setUp() {
        super.setUp()
        sut = WeatherParser()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // Парсинг текущей погоды из валидного JSON
    func testParse_validJSON_returnsExpectedCurrentWeather() throws {
        let (current, _) = try makeSUT()
        
        XCTAssertEqual(current.temperature, 5.5)
        XCTAssertEqual(current.feelsLike, 3.2)
        XCTAssertEqual(current.humidity, 80)
        XCTAssertEqual(current.pressure, 1013)
        XCTAssertEqual(current.windSpeed, 4.5)
        XCTAssertEqual(current.visibility, 10000)
        XCTAssertEqual(current.clouds, 75)
        XCTAssertEqual(current.description, "cloudy")
        XCTAssertEqual(current.icon, "04d")
    }

    // Парсинг дневного прогноза из валидного JSON
    func testParse_validJSON_returnsExpectedDailyForecast() throws {
        let (_, daily) = try makeSUT()
        
        XCTAssertEqual(daily.count, 1)
        
        let day = try XCTUnwrap(daily.first)
        
        XCTAssertEqual(day.tempMin, 2.0)
        XCTAssertEqual(day.tempMax, 8.0)
        XCTAssertEqual(day.pressure, 1012)
        XCTAssertEqual(day.humidity, 85)
        XCTAssertEqual(day.visibility, 10000)
        XCTAssertEqual(day.clouds, 80)
        XCTAssertEqual(day.description, "light rain")
        XCTAssertEqual(day.icon, "10d")
    }
}

// MARK: - Helpers
private extension WeatherParserTests {
    func makeSUT(
        fixture: String = "onecall_minimal"
    ) throws -> (TodayWeather, [DayForecast]) {
        
        let data = try loadFixture(fixture)
        return try sut.parse(data: data)
    }
    
    func loadFixture(_ name: String, extension ext: String = "json") throws -> Data {
        let bundle = Bundle(for: WeatherParserTests.self)
        let url = bundle.url(forResource: name, withExtension: ext, subdirectory: "Fixtures")
        ?? bundle.url(forResource: name, withExtension: ext)
        
        let unwrapped = try XCTUnwrap(
            url,
            "Fixture \(name).\(ext) not found. Add it to Copy Bundle Resources."
        )
        
        return try Data(contentsOf: unwrapped)
    }
}
