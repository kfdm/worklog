//
//  OpenCommand.swift
//  worklog
//
//  Created by ST20638 on 2019/10/18.
//  Copyright © 2019 ST20638. All rights reserved.
//

import SwiftCLI
import Foundation

class OpenCommand: Command {
    let name = "open"
    let date = OptionalParameter()
    var shortDescription = "Open worklog for editing"

    func execute() throws {
        let path: URL
        let basePath = UserDefaults.shared.path(for: .worklog)

        let config = WorklogConfig(path: basePath!.path)
        if let lookup = date.value {
            let parsed = DateComponents()
            path = config.entry(date: parsed)
        } else {
            let today = Calendar.current.dateComponents(in: .current, from: .init())
            path = config.entry(date: today)
        }

        if FileManager.default.fileExists(atPath: path.path) {
            try shell("open", path.path)
        } else {
            changeCurrentDirectoryPath(config.path)
            try shell("hugo", "new", "--kind", "worklog", path.path)
            try shell("open", path.path)
        }
    }
}
