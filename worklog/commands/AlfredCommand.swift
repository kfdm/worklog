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

struct AlfredJson: Codable {
    let items: [AlfredRow]
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
    func execute() throws {
        var dates = [String]()
        var items = [AlfredRow]()

        var basePath =  Hugo.default.basePath
        basePath.appendPathComponent("content")
        basePath.appendPathComponent("worklog")

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        items.append(AlfredRow(arg: formatter.string(from: Date()), title: "Worklog for Today", icon: nil))
        dates.append(formatter.string(from: Date()))

        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: .init())!
        items.append(AlfredRow(arg: formatter.string(from: tomorrow ), title: "Worklog for Tomorrow", icon: nil))
        dates.append(formatter.string(from: tomorrow ))

        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: .init())!
        items.append(AlfredRow(arg: formatter.string(from: yesterday ), title: "Worklog for Yesterday", icon: nil))
        dates.append(formatter.string(from: yesterday ))

        // Get list of path URLs
        try Hugo.default.entries()
            // Split on . to find just the date
            .map { $0.lastPathComponent.components(separatedBy: ".").first! }
            // Find the dates we haven't added
            .filter { !dates.contains($0) }
            // Then add them to our row
            .forEach { (path) in
                items.append(AlfredRow(arg: path, title: path, icon: nil))
        }

        let jsonData = try! JSONEncoder().encode(AlfredJson(items: items))
        let jsonString = String(data: jsonData, encoding: .utf8)!
        stdout <<< jsonString
    }
}

class AlfredGroup: CommandGroup {
    let name = "alfred"
    let shortDescription = "Support for Alfred"
    let children: [Routable] = [AlfredInstallCommand(), AlfredRunCommand()]
}
