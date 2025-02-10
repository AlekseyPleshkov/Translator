//
//  StringsDocument.swift
//  Localizator
//
//  Created by Aleksey Pleshkov on 07.02.2025.
//

import SwiftUI
import UniformTypeIdentifiers

struct StringsDocument: FileDocument {
    static let readableContentTypes: [UTType] = [
        .xcstrings
    ]
    static let writableContentTypes: [UTType] = [
        .xcstrings
    ]
    
    var data: LocalizationModel
    
    private let encoder: JSONEncoder = JSONEncoder()
    private let decoder: JSONDecoder = JSONDecoder()
    
    init(data: Data) throws {
        self.data = try decoder.decode(LocalizationModel.self, from: data)
    }
    
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            self.data = try decoder.decode(LocalizationModel.self, from: data)
        }
        else {
            throw CocoaError(.fileNoSuchFile)
        }
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = try encoder.encode(data)
        return FileWrapper(regularFileWithContents: data)
    }
}
