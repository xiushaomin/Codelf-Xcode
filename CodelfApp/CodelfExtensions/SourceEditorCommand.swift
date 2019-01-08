//
//  SourceEditorCommand.swift
//  CodelfExtensions
//
//  Created by MarkXiu on 2019/1/8.
//  Copyright © 2019 MarkXiu. All rights reserved.
//

import Foundation
import XcodeKit
import AppKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        if invocation.commandIdentifier.components(separatedBy: ".").last == "codelf" {
            if let params = selectedString(with: invocation).addingPercentEncoding(withAllowedCharacters: CharacterSet.capitalizedLetters),
                let url = URL(string: "https://unbug.github.io/codelf/#" + params) {
                NSWorkspace.shared.open(url)
            } else {
                NSWorkspace.shared.open(URL(string: "https://unbug.github.io/codelf/")!)
            }
        }
        completionHandler(nil)
    }
    
    func selectedString(with invocation: XCSourceEditorCommandInvocation) -> String {
        var results = ""
        for case let range as XCSourceTextRange in invocation.buffer.selections {
            let startLine = range.start.line
            let startColumn = range.start.column
            let endLine = range.end.line
            let endColumn = range.end.column
            
            for index in startLine...endLine {
                
                let line = invocation.buffer.lines[index] as! NSString
                var text: String
                
                if startLine == endLine {
                    text = line.substring(with: NSMakeRange(startColumn, endColumn - startColumn))
                } else if index == startLine {
                    text = line.substring(from: startColumn)
                } else if index == endLine {
                    text = line.substring(to: endColumn)
                } else {
                    text = line as String
                }
                
                if text.count > 0 {
                    results.append(text)
                }
            }
        }
        return results.trimmingCharacters(in: CharacterSet.whitespaces).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
}


