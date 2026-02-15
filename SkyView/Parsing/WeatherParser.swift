//
//  WeatherParser.swift
//  SkyView
//
//  Created by Adam on 13.02.2026.
//

import Foundation

/// Источник разбора погодных данных в обобщённые типы.
/// Позволяет подменять реализацию в тестах.
protocol WeatherParsing: Sendable {
    /// Парсит JSON из `data` в одну сущность и массив сущностей.
    /// - Parameters:
    ///   - data: Сырые данные ответа (JSON).
    /// - Returns: Кортеж: одна сущность (single) и массив сущностей (list).
    /// - Single: Тип единственного объекта (например, текущая погода), конформный `MappableFromDictionary`.
    /// - Element: Тип элемента списка (например, день прогноза), конформный `MappableFromDictionary`.
    func parse<Single: MappableFromDictionary, Element: MappableFromDictionary>(
        data: Data
    ) throws -> (single: Single, list: [Element])
}

/// Парсер погодных данных через C++ мост. Возвращает обобщённые типы, реализующие `MappableFromDictionary`.
final class WeatherParser: WeatherParsing {
    func parse<Single: MappableFromDictionary, Element: MappableFromDictionary>(
        data: Data
    ) throws -> (single: Single, list: [Element]) {
        guard let jsonString = String(data: data, encoding: .utf8) else {
            throw NetworkError.unknown(parsingError("Invalid UTF-8"))
        }
        let single: Single = try parseSingle(jsonString)
        let list: [Element] = try parseList(jsonString)
        return (single, list)
    }
}

// MARK: - Helpers
private extension WeatherParsing {
    /// Разбирает единственный объект из JSON-строки.
    /// - Parameter json: строка JSON.
    /// - Returns: объект типа `Single`.
    /// - Throws: ошибка при разборе или маппинге.
    func parseSingle<Single: MappableFromDictionary>(_ json: String) throws -> Single {
        let dict = try SkyViewJSONBridge.parseCurrent(fromJSON: json)
        return try mapDict(dict, id: nil)
    }

    /// Разбирает массив объектов из JSON-строки.
    /// - Parameter json: строка JSON.
    /// - Returns: массив элементов типа `Element`.
    /// - Throws: ошибка при разборе или маппинге.
    func parseList<Element: MappableFromDictionary>(_ json: String) throws -> [Element] {
        let arr = try SkyViewJSONBridge.parseDaily(fromJSON: json)
        return arr.enumerated().compactMap { index, dict in
            let dt = (dict[kSkyViewKeyDt] as? NSNumber)?.doubleValue ?? .zero
            return Element.from(dict, id: "\(index)_\(Int(dt))")
        }
    }

    /// Маппит словарь в тип, реализующий `MappableFromDictionary`.
    /// - Parameters:
    ///   - dict: словарь ключ–значение.
    ///   - id: опциональный идентификатор (для типов, где он нужен при создании из словаря).
    /// - Returns: экземпляр типа `Mapped`.
    /// - Throws: ошибка, если маппинг вернул `nil`.
    func mapDict<Mapped: MappableFromDictionary>(
        _ dict: [String: Any],
        id: String?
    ) throws -> Mapped {
        guard let value = Mapped.from(dict, id: id) else {
            throw NetworkError.unknown(parsingError("Mapping failed"))
        }
        return value
    }

    /// Формирует `NSError` для ошибок парсера.
    /// - Parameter message: текст ошибки.
    /// - Returns: `NSError` с доменом парсера.
    func parsingError(_ message: String) -> NSError {
        NSError(
            domain: "WeatherParser",
            code: -1,
            userInfo: [NSLocalizedDescriptionKey: message]
        )
    }
}
