//
//  DataLoading.swift
//  SkyView
//
//  Created by Adam on 13.02.2026.
//

import Foundation

protocol DataLoading: Sendable {
    func load(from url: URL) async throws -> Data
}
