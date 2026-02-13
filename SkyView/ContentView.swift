//
//  ContentView.swift
//  SkyView
//
//  Created by Adam on 12.02.2026.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: WeatherListViewModel

    var body: some View {
        VStack(spacing: 16) {
            Button("Загрузить") {
                Task { await viewModel.refresh() }
            }
            .disabled(viewModel.state.isLoading)

            switch viewModel.state {
            case .idle:
                EmptyView()
            case .loading:
                ProgressView()
            case .loaded(let items):
                Text("Загружено городов: \(items.count)")
            case .failed(let message):
                Text(message)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
    }
}
