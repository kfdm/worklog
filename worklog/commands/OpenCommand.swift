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

        switch date.value {
        case "today", nil:
            let today = Calendar.current.dateComponents(in: .current, from: .init())
            path = config.entry(date: today)
        case "tomorrow":
            let interval = TimeInterval(24 * 60 * 60)
            let tomorrow = Calendar.current.dateComponents(in: .current, from: Date().addingTimeInterval(interval))
            path = config.entry(date: tomorrow)
        case "yesterday":
            let interval = TimeInterval(24 * 60 * 60) * -1
            let yesterday = Calendar.current.dateComponents(in: .current, from: Date().addingTimeInterval(interval))
            path = config.entry(date: yesterday)
        default:
            let dateParser = DateFormatter()
            dateParser.dateFormat = "yyyy-MM-dd"
            let parsed = Calendar.current.dateComponents(in: .current, from: dateParser.date(from: date.value!)!)
            path = config.entry(date: parsed)
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
