//
//  NetworkService.swift
//  SkyView
//
//  Created by Adam on 13.02.2026.
//

import Foundation

final class NetworkService {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
}

// MARK: - DataLoading
extension NetworkService: DataLoading {
    func fetchData(from url: URL) async throws -> Data {
        let (data, response) = try await performRequest(to: url)
        try validateDataNotEmpty(data)
        return try validateHTTPResponse(response, data: data)
    }
}

// MARK: - Private Methods
private extension NetworkService {
    func performRequest(to url: URL) async throws -> (Data, URLResponse) {
        do {
            return try await session.data(from: url)
        } catch let urlError as URLError where urlError.code == .timedOut {
            throw NetworkError.timeout
        } catch {
            throw NetworkError.unknown(error)
        }
    }
    
    func validateDataNotEmpty(_ data: Data) throws {
        guard !data.isEmpty else { throw NetworkError.noData }
    }
    
    func validateHTTPResponse(_ response: URLResponse, data: Data) throws -> Data {
        guard let http = response as? HTTPURLResponse else {
            throw NetworkError.unknown(networkError("Invalid response"))
        }
        switch http.statusCode {
        case 200...299: return data
        case 400...499: throw NetworkError.clientError(statusCode: http.statusCode)
        case 500...599: throw NetworkError.serverError(statusCode: http.statusCode)
        default:
            throw NetworkError.unknown(networkError("HTTP \(http.statusCode)", code: http.statusCode))
        }
    }

    func networkError(_ message: String, code: Int = -1) -> NSError {
        NSError(domain: "NetworkService", code: code, userInfo: [NSLocalizedDescriptionKey: message])
    }
}
