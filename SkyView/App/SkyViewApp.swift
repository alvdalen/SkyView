//
//  SkyViewApp.swift
//  SkyView
//
//  Created by Adam on 12.02.2026.
//

import SwiftUI

@main
struct SkyViewApp: App {
    @State private var container = DependencyContainer()

    var body: some Scene {
        WindowGroup {
            WeatherListConfigurator.configure(container: container)
        }
    }
}
