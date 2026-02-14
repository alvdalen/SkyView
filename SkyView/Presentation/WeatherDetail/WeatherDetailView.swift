//
//  WeatherDetailView.swift
//  SkyView
//
//  Created by Adam on 14.02.2026.
//

import SwiftUI

struct WeatherDetailView: View {
    @StateObject var viewModel: WeatherDetailViewModel

    init(viewModel: WeatherDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        Text(viewModel.cityDisplayName)
            .font(.title2)
            .padding()
    }
}
