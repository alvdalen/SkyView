//
//  City.swift
//  SkyView
//
//  Created by Adam on 13.02.2026.
//

struct City: Identifiable, Hashable, Sendable {
    let id: String
    let name: String
    let country: String
    let lat: Double
    let lon: Double
    
    var displayName: String {
        "\(name), \(country)"
    }
}
