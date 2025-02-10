//
//  LocalizationResult.swift
//  Translator
//
//  Created by Aleksey Pleshkov on 10.02.2025.
//

import Foundation

struct LocalizationResult: Sendable {
    let document: StringsDocument
    let sourceKeysCount: Int
    let translatedKeysCount: Int
}
