//
//  NetworkService.swift
//  SkyView
//
//  Created by Adam on 13.02.2026.
//

import Foundation

final class NetworkService: DataLoading {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func load(from url: URL) async throws -> Data {
        let data: Data
        let response: URLResponse
        
        do {
            (data, response) = try await session.data(from: url)
        } catch let urlError as URLError where urlError.code == .timedOut {
            throw NetworkError.timeout
        } catch {
            throw NetworkError.unknown(error)
        }
        
        guard !data.isEmpty else {
            throw NetworkError.noData
        }
        
        guard let http = response as? HTTPURLResponse else {
            throw NetworkError.unknown(
                NSError(
                    domain: "NetworkService",
                    code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"]
                )
            )
        }
        
        switch http.statusCode {
        case 200...299:
            return data
        case 400...499:
            throw NetworkError.clientError(statusCode: http.statusCode)
        case 500...599:
            throw NetworkError.serverError(statusCode: http.statusCode)
        default:
            throw NetworkError.unknown(
                NSError(
                    domain: "NetworkService",
                    code: http.statusCode,
                    userInfo: [NSLocalizedDescriptionKey: "HTTP \(http.statusCode)"]
                )
            )
        }
    }
}
