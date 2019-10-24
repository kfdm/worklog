//
//  AlfredCommand.swift
//  worklog
//
//  Created by Paul Traylor on 2019/10/19.
//  Copyright © 2019 Paul Traylor. All rights reserved.
//

import SwiftCLI
import Foundation

struct AlfredIcon: Codable {
    let path: String
}

struct AlfredRow: Codable {
    let arg: String
    let title: String
    let icon: AlfredIcon?
}

extension AlfredRow {
    init (title: String, date: Date, icon: AlfredIcon? = nil) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        self.title = title
        self.arg = formatter.string(from: date)
        self.icon = icon
    }
}

struct AlfredJson: Codable {
    let items: [AlfredRow]
}

extension AlfredJson {
    var json: String {
        let jsonData = try! JSONEncoder().encode(self)
        return String(data: jsonData, encoding: .utf8)!
    }
}

class AlfredInstallCommand: Command {
    let name = "install"
    let shortDescription = "Install Alfred support"

    func execute() throws {
        guard let alfred = UserDefaults.init(suiteName: "com.runningwithcrayons.Alfred") else {
            throw CLI.Error(message: "Alfred not found")
        }
    }
}

class AlfredRunCommand: Command {
    let name = "run"
    let shortDescription = "Output for Alfred filter workflow"
    func execute() throws {
        var items = [AlfredRow]()

        items.append(AlfredRow(title: "Worklog for Today", date: Date()))

        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: .init())!
        items.append(AlfredRow(title: "Worklog for Tomorrow", date: tomorrow, icon: AlfredIcon(path: "tomorrow.png")))

        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: .init())!
        items.append(AlfredRow(title: "Worklog for Yesterday", date: yesterday, icon: AlfredIcon(path: "yesterday.png")))

        // Get the dates we've artifically added
        let dates = items.map { $0.arg }
        // Get list of path URLs
        items.append(contentsOf: try Hugo.default.entries()
            // Sort by path
            .sorted { $0.path.path > $1.path.path}
            // Get the last 10
            .prefix(10)
            // Find the dates we haven't added
            .filter { !dates.contains($0.frontmatter.date!) }
            // Then add them to our row
            .map { AlfredRow(arg: $0.frontmatter.date!, title: $0.frontmatter.title, icon: nil) }
        )

        stdout <<< AlfredJson(items: Array(items.prefix(10))).json
    }
}

class AlfredGroup: CommandGroup {
    let name = "alfred"
    let shortDescription = "Support for Alfred"
    let children: [Routable] = [AlfredInstallCommand(), AlfredRunCommand()]
}
