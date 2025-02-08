//
//  ContentView.swift
//  Localizator
//
//  Created by Aleksey Pleshkov on 07.02.2025.
//

import SwiftUI
import Translation

struct ContentView: View {
    // MARK: - Private Properties
    
    private let localizationManager = LocalizationManager()
    
    @State
    private var statusText: LocalizedStringKey = "Status.ImportFile"
    @State
    private var isFileImportedPresenter = false
    @State
    private var isFileExporterPresenter = false
    @State
    private var processedDocument: StringsDocument?
    
    @State
    private var supportedTargetLanguages: [Locale.Language] = []
    @State
    private var supportedDestinationLanguages: [Locale.Language] = []
    @State
    private var selectedTargetLanguage: Locale.Language?
    @State
    private var selectedDestinationLanguage: Locale.Language?
    
    @State
    private var configuration: TranslationSession.Configuration?

    private var isReadyToTranslate: Bool {
        selectedTargetLanguage != nil && selectedDestinationLanguage != nil && processedDocument != nil
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading) {
            
            VStack(alignment: .leading, spacing: 10) {
                Button("Button.ImportFile", systemImage: "icloud.and.arrow.up") {
                    isFileImportedPresenter = true
                }
                .buttonStyle(PrimaryButtonStyle())

                LabeledContent("Picker.TargetLanguage") {
                    Picker(selection: $selectedTargetLanguage, label: EmptyView()) {
                        ForEach(supportedTargetLanguages, id: \.self) { item in
                            Text(item.id).tag(item)
                        }
                    }
                    .labelsHidden()
                }
                .labeledContentStyle(VerticalLabeledContentStyle())

                LabeledContent("Picker.DestinationLanguage") {
                    Picker(selection: $selectedDestinationLanguage, label: EmptyView()) {
                        ForEach(supportedDestinationLanguages, id: \.self) { item in
                            Text(item.id).tag(item)
                        }
                    }
                    .labelsHidden()
                }
                .labeledContentStyle(VerticalLabeledContentStyle())
                
                Button("Button.Translate", systemImage: "icloud.and.arrow.down") {
                    prepareTranslationSession()
                }
                .buttonStyle(PrimaryButtonStyle())
                .disabled(!isReadyToTranslate)
            }
            .padding()
            
            Spacer()

            Text(statusText)
                .padding(.horizontal, 16)
                .padding(.vertical, 4)
                .frame(maxWidth: .infinity)
                .background(.thinMaterial)
        }
        .translationTask(configuration) { session in
            translateStringsFile(session)
        }
        .fileImporter(isPresented: $isFileImportedPresenter, allowedContentTypes: [.xcstrings]) { result in
            loadStringsFile(result)
        }
        .fileExporter(isPresented: $isFileExporterPresenter, document: processedDocument, contentType: .xcstrings) { result in
            if case .success = result {
                isFileImportedPresenter = false
                isFileExporterPresenter = false
                processedDocument = nil
            }
        }
    }
}

// MARK: - Private Methods

private extension ContentView {
    func loadStringsFile(_ fileURL: Result<URL, Error>) {
        Task {
            do {
                statusText = "Status.Importing"
                
                let url = try fileURL.get()
                let document = try await localizationManager.loadDocumentFile(by: url)
                
                processedDocument = document
                supportedTargetLanguages = await localizationManager.loadLanguages(for: document)
                supportedDestinationLanguages = await localizationManager.loadLanguages()
                
                statusText = "Status.FileImported"
            } catch {
                statusText = "Error: \(error.localizedDescription)"
            }
        }
    }
    
    func prepareTranslationSession() {
        guard let selectedTargetLanguage, let selectedDestinationLanguage else {
            return
        }
        configuration = TranslationSession.Configuration(
            source: selectedTargetLanguage,
            target: selectedDestinationLanguage
        )
    }
    
    func translateStringsFile(_ session: TranslationSession) {
        guard let document = processedDocument else { return }

        Task {
            do {
                statusText = "Status.Translation"
                try await session.prepareTranslation()
                processedDocument = try await localizationManager.translateDocument(document, session: session)
                isFileExporterPresenter = true
                statusText = "Status.Finished"
            } catch {
                statusText = "Error: \(error.localizedDescription)"
            }
        }
    }
}

// MARK: - Preview

#Preview {
    ContentView()
        .frame(width: 300, height: 300)
        .containerBackground(.thinMaterial, for: .window)
        .toolbarBackgroundVisibility(.hidden, for: .windowToolbar)
}
