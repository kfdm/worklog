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
        let basePath = UserDefaults.shared.path(for: .worklog)!
        let site = Hugo.default

        switch date.value {
        case "t", "today", nil:
            path = site.worklog(for: .init())
        case "to", "tomorrow":
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: .init())!
            path = site.worklog(for: tomorrow)
        case "y", "yesterday":
            let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: .init())!
            path = site.worklog(for: yesterday)
        default:
            let dateParser = DateFormatter()
            dateParser.dateFormat = "yyyy-MM-dd"
            let lookup = dateParser.date(from: date.value!)!
            path = site.worklog(for: lookup)
        }

        if FileManager.default.fileExists(atPath: path.path) {
            try shell("open", path.path)
        } else {
            _ = changeCurrentDirectoryPath(site.basePath.path)
            try shell("hugo", "new", "--kind", "worklog", path.path)
            try shell("open", path.path)
        }
    }
}
