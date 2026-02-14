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
        Group {
            switch viewModel.state {
            case .idle, .loading:
                if viewModel.state.isLoading && (viewModel.loadedItems ?? []).isEmpty {
                    VStack(spacing: 14) {
                        ProgressView()
                        Text("Загрузка...")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    EmptyView()
                }
            case .loaded(let items):
                listContent(items: items)
            case .failed(let message):
                VStack(spacing: 14) {
                    Text(message)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                    Button("Повторить") {
                        Task { await viewModel.refresh() }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .padding()
        .task {
            if (viewModel.loadedItems ?? []).isEmpty {
                await viewModel.refresh()
            }
        }
    }

    private func listContent(items: [CityWeather]) -> some View {
        List {
            ForEach(items) { item in
                WeatherCityCell(
                    weather: item,
                    isRefreshing: viewModel.refreshingCityId == item.city.id,
                    onRefresh: {
                        Task { await viewModel.refreshCity(item.city.id) }
                    }
                )
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
        }
        .listStyle(.plain)
    }
}
