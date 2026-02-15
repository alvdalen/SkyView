//
//  NetworkError.swift
//  SkyView
//
//  Created by Adam on 13.02.2026.
//

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case timeout
    case clientError(statusCode: Int)
    case serverError(statusCode: Int)
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .noData: return "No data received"
        case .timeout: return "Request timed out"
        case .clientError(let code): return "Client error: \(code)"
        case .serverError(let code): return "Server error: \(code)"
        case .unknown(let error): return error.localizedDescription
        }
    }
}
