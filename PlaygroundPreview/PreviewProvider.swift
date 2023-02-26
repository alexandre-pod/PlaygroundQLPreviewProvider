//
//  PreviewProvider.swift
//  PlaygroundPreview
//
//  Created by Alexandre Podlewski on 26/02/2023.
//

import Cocoa
import QuickLookUI

enum PreviewError: Error {
    case unsupportedFileExtension
    case unsupportedPlaygroundFormat
}

class PreviewProvider: QLPreviewProvider, QLPreviewingController {

    private let fileManager: FileManager = .default

    func providePreview(for request: QLFilePreviewRequest) async throws -> QLPreviewReply {

        guard request.fileURL.pathExtension == "playground" else {
            throw PreviewError.unsupportedFileExtension
        }

        return QLPreviewReply(
            dataOfContentType: UTType.plainText,
            contentSize: CGSize.init(width: 800, height: 800)
        ) { (replyToUpdate : QLPreviewReply) in

            replyToUpdate.stringEncoding = .utf8

            let contentsFileURL = request.fileURL.appendingPathComponent("Contents.swift", conformingTo: .fileURL)

            guard let playgroundContents = self.fileManager.contents(atPath: contentsFileURL.path) else {
                throw PreviewError.unsupportedPlaygroundFormat
            }

            return playgroundContents
        }
    }
}
