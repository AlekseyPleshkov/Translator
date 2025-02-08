//
//  LocalizationModel.swift
//  Localizator
//
//  Created by Aleksey Pleshkov on 07.02.2025.
//

import Foundation

struct LocalizationModel: Codable {
    let sourceLanguage: String
    let version: String
    var strings: [String: LocalizedStrings]
}

struct LocalizedStrings: Codable {
    var localizations: [String: LocalizedLanguage]?
    let shouldTranslate: Bool?
}

struct LocalizedLanguage: Codable {
    var stringUnit: LocalizedStringUnit
}

struct LocalizedStringUnit: Codable {
    let state: String
    var value: String
}
