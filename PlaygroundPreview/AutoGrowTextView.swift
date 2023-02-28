//
//  AutoGrowTextView.swift
//  PlaygroundPreview
//
//  Created by Alexandre Podlewski on 01/03/2023.
//

import AppKit

class AutoGrowTextView: NSTextView {

    override var intrinsicContentSize: NSSize {
        return self.textStorage?.size() ?? super.intrinsicContentSize
    }
}
