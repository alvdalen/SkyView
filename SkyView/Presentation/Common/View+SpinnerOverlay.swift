//
//  View+SpinnerOverlay.swift
//  SkyView
//
//  Created by Adam on 15.02.2026.
//

import SwiftUI

extension View {
    func spinnerOverlay(isLoading: Bool) -> some View {
        overlay {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                ProgressView()
            }
            .opacity(isLoading ? 1 : 0)
            .allowsHitTesting(isLoading)
            .animation(.easeOut(duration: 0.18), value: isLoading)
        }
    }
}
