//
//  Language+ID.swift
//  Localizator
//
//  Created by Aleksey Pleshkov on 08.02.2025.
//

import Translation

extension Locale.Language: @retroactive Identifiable, Sendable {
    public var id: String {
        minimalIdentifier
    }
}
