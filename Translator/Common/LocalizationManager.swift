//
//  LocalizationManager.swift
//  Localizator
//
//  Created by Aleksey Pleshkov on 07.02.2025.
//

import Foundation
@preconcurrency import Translation

actor LocalizationManager {
    // MARK: - Private Properties
    
    private var supportedLanguages: [Locale.Language] = []
    
    // MARK: - Internal Methods
    
    func loadLanguages() async -> [Locale.Language] {
        guard supportedLanguages.isEmpty else {
            return supportedLanguages
        }
        supportedLanguages = await LanguageAvailability().supportedLanguages
        return supportedLanguages
    }
    
    func loadLanguages(for document: StringsDocument) async -> [Locale.Language] {
        let documentLanguages: [String] = document.data.strings
            .values
            .compactMap { $0.localizations?.keys }
            .flatMap { $0 }
        let uniqueDocumentLanguages = Set(documentLanguages)
        return await loadLanguages().filter {
            uniqueDocumentLanguages.contains($0.id)
        }
    }
    
    func loadDocumentFile(by url: URL) async throws -> StringsDocument {
        guard url.startAccessingSecurityScopedResource() else {
            throw CocoaError(.fileReadNoPermission)
        }
        let data = try Data(contentsOf: url)
        url.stopAccessingSecurityScopedResource()
        return try StringsDocument(data: data)
    }
    
    func loadStats() {
        
    }
    
    func translateDocument(_ document: StringsDocument, session: TranslationSession) async throws -> LocalizationResult {
       guard
            let sourceLanguageCode = session.sourceLanguage?.id,
            let targetLanguageCode = session.targetLanguage?.id
        else {
            throw CocoaError(.featureUnsupported)
        }
        
        var document = document
        var translatedStringsCount = 0

        for (key, string) in document.data.strings {
            let data = string.localizations?[sourceLanguageCode]
            let value = data?.stringUnit.value
            
            let targetData = string.localizations?[targetLanguageCode]
            let targetState = targetData?.stringUnit.state
            
            guard let value, targetState != "translated" else {
                continue
            }
            
            let translatedValue = try await session.translate(value).targetText
            
            document.data.strings[key]?.localizations?[targetLanguageCode] = LocalizedLanguage(
                stringUnit: LocalizedStringUnit(state: "needs_review", value: translatedValue)
            )
            translatedStringsCount += 1
        }
        
        return LocalizationResult(
            document: document,
            sourceKeysCount: document.data.strings.count,
            translatedKeysCount: translatedStringsCount
        )
    }
}
