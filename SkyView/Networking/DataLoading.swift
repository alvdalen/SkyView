//
//  DataLoading.swift
//  SkyView
//
//  Created by Adam on 13.02.2026.
//

import Foundation

protocol DataLoading: Sendable {
    /// Загружает данные по указанному URL.
    ///
    /// Выполняет HTTP‑запрос, проверяет ответ и возвращает тело ответа в виде `Data`.
    /// При таймауте, пустом ответе или ошибках HTTP (4xx/5xx) выбрасывает соответствующую `NetworkError`.
    ///
    /// - Parameter url: URL ресурса для загрузки.
    /// - Returns: Данные ответа (не пустые).
    /// - Throws: `NetworkError` при ошибке сети, таймауте, пустых данных или неуспешном HTTP‑статусе.
    func fetchData(from url: URL) async throws -> Data
}
