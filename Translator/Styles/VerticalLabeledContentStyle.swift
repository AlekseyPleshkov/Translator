//
//  VerticalLabeledContentStyle.swift
//  ProgressTracker
//
//  Created by Aleksey Pleshkov on 19.01.2025.
//

import SwiftUI

struct VerticalLabeledContentStyle: LabeledContentStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
            configuration.content
        }
    }
}
