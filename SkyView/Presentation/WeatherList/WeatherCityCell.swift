//
//  WeatherCityCell.swift
//  SkyView
//
//  Created by Adam on 14.02.2026.
//

import SwiftUI

struct WeatherCityCell: View {
    let weather: CityWeather
    let isRefreshing: Bool
    let onRefresh: () -> Void
    
    private var isCold: Bool {
        weather.current.temperature < 10
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(weather.city.displayName)
                    .font(.system(size: 18, weight: .semibold))
                Text(weather.current.description)
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
            }
            Spacer()
            HStack(spacing: 8) {
                Text("\(Int(weather.current.temperature))°")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(isCold ? .blue : .primary)
                Image(systemName: iconName(for: weather.current.icon))
                    .font(.system(size: 20))
                    .foregroundStyle(isCold ? .blue : .primary)
                    .frame(width: 28)
            }
            Button {
                onRefresh()
            } label: {
                if isRefreshing {
                    ProgressView()
                        .controlSize(.small)
                        .frame(width: 24, height: 24)
                } else {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                        .frame(width: 24, height: 24)
                }
            }
            .buttonStyle(.plain)
            .disabled(isRefreshing)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 18)
        .background(backgroundColor)
    }
    
    private var backgroundColor: some View {
        RoundedRectangle(cornerRadius: 18, style: .continuous)
            .fill(isCold ? Color(red: 0.92, green: 0.95, blue: 1.0) : Color(.systemBackground))
            .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
    }
    
    private func iconName(for icon: String) -> String {
        if icon.contains("01") { return "sun.max.fill" }
        if icon.contains("02") { return "cloud.sun.fill" }
        if icon.contains("03") || icon.contains("04") { return "cloud.fill" }
        if icon.contains("09") || icon.contains("10") { return "cloud.rain.fill" }
        if icon.contains("11") { return "cloud.bolt.fill" }
        if icon.contains("13") { return "cloud.snow.fill" }
        return "cloud.fill"
    }
}

// MARK: - Constants
private extension WeatherCityCell {
    enum LocalConstats {
        
    }
}
