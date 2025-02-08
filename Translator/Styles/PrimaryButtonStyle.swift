//
//  PrimaryButtonStyle.swift
//  Localizator
//
//  Created by Aleksey Pleshkov on 19.01.2025.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    // MARK: - Private Properties
    
    @Environment(\.isEnabled)
    private var isEnabled: Bool
    
    // MARK: - MakeBody
    
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity)
            .padding()
            .background(isEnabled ? Color.accent : Color.accent.opacity(0.5))
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
            .lineLimit(1)
    }
}
