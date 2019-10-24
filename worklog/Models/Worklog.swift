//
//  Worklog.swift
//  worklog
//
//  Created by ST20638 on 2019/10/24.
//  Copyright © 2019 Paul Traylor. All rights reserved.
//

import Foundation
import Yams

struct Worklog {
    let path: URL
    var frontmatter: Frontmatter
    var text: String
}

private enum WorklogParseState {
    case start
    case yaml
    case body
}

extension Worklog {
    init(path: URL) throws {
        var state = WorklogParseState.start
        self.path = path

        var inputYaml = [String]()
        var bodyBuffer = [String]()

        let raw = try String(contentsOf: path)

        raw.components(separatedBy: .newlines).forEach { (line) in
            switch state {
            case .start where line == "---":
                state = .yaml
            case .start:
                state = .body
            case .yaml where line == "---":
                state = .body
            case .yaml:
                inputYaml.append(line)
            case .body:
                bodyBuffer.append(line)
            }
        }
        self.frontmatter = Frontmatter(from: inputYaml.joined(separator: "\n"))
        self.text = bodyBuffer.joined(separator: "\n")
    }
}
