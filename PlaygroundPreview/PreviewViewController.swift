//
//  PreviewViewController.swift
//  PlaygroundPreview
//
//  Created by Alexandre Podlewski on 01/03/2023.
//

import AppKit
import QuickLookUI
import Highlightr

class PreviewViewController: NSViewController, QLPreviewingController {

    private lazy var textView = AutoGrowTextView()
    private let fileManager: FileManager = .default

    override func loadView() {
        let scrollView = NSScrollView(frame: NSRect(x: 0, y: 0, width: 100, height: 500))
        view = scrollView

        scrollView.borderType = .noBorder
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = true

        scrollView.documentView = textView

        textView.font = .monospacedSystemFont(ofSize: 12, weight: .regular)
    }

    func preparePreviewOfFile(at url: URL, completionHandler handler: @escaping (Error?) -> Void) {

        let highlightr = Highlightr()!
        highlightr.setTheme(to: "atom-one-dark")
        do {
            let contents = findContentsToDisplay(at: url)
            let showTitles = contents.count > 1
            try contents.forEach { name, contentURL in
                if showTitles {
                    let title = NSAttributedString(
                        string: "📄 \(name)\n",
                        attributes: [
                            .foregroundColor: NSColor.lightGray,
                            .font: NSFont.boldSystemFont(ofSize: 25)
                        ]
                    )
                    textView.textStorage?.append(title)
                }
                let contents = try String(contentsOf: contentURL)
                let highlightedCode = highlightr.highlight(contents, as: "swift", fastRender: false)!
                textView.textStorage?.append(highlightedCode)
            }
        } catch {
            textView.string = "Error: \(error)"
        }

        textView.frame = CGRect(origin: .zero, size: textView.intrinsicContentSize)

        handler(nil)
    }

    // MARK: - Private

    private typealias DisplayableContent = (name: String, url: URL)

    private func findContentsToDisplay(at url: URL) -> [DisplayableContent] {
        var displayableContents: [DisplayableContent] = []
        let contentsFileURL = url.appendingPathComponent("Contents.swift", conformingTo: .fileURL)
        if isValidFileURL(contentsFileURL) {
            displayableContents.append(("Contents.swift", contentsFileURL))
        }
        let pagesFileURL = url.appendingPathComponent("Pages", conformingTo: .directory)
        if isValidDirectoryURL(pagesFileURL) {
            try? fileManager.contentsOfDirectory(at: pagesFileURL, includingPropertiesForKeys: nil)
                .filter { $0.pathExtension == "xcplaygroundpage" }
                .forEach {
                    let contentsURL = $0.appendingPathComponent("Contents.swift", conformingTo: .fileURL)
                    if isValidFileURL(contentsURL) {
                        displayableContents.append(($0.lastPathComponent, contentsURL))
                    }
                }
        }

        return displayableContents
    }

    private func isValidFileURL(_ url: URL) -> Bool {
        var isDirectory: ObjCBool = false
        return fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory)
        && !isDirectory.boolValue
    }

    private func isValidDirectoryURL(_ url: URL) -> Bool {
        var isDirectory: ObjCBool = false
        return fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory)
        && isDirectory.boolValue
    }
}
