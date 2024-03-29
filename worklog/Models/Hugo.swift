//
//  Hugo.swift
//  worklog
//
//  Created by Paul Traylor on 2019/10/17.
//  Copyright © 2019 Paul Traylor. All rights reserved.
//

import Foundation

struct Hugo {
    var basePath: URL
}

// MARK: — Path Functions
extension Hugo {
    static var `default` : Hugo {
        let basePath = UserDefaults.shared.path(for: .worklog)!
        return Hugo(basePath: basePath)
    }

    var worklogPath: URL {
        return basePath
            .appendingPathComponent("content")
            .appendingPathComponent("worklog")
    }
}

// MARK: — File Functions
extension Hugo {
    var config: HugoConfig {
        return try! HugoConfig.load(from: basePath.appendingPathComponent("config.yaml"))
    }

    func worklog(for date: Date) -> URL {
        return worklog(for: Calendar.current.dateComponents(in: .current, from: date))
    }
    func worklog(for date: DateComponents) -> URL {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        return worklogPath
            .appendingPathComponent(String(format: "%04d", arguments: [date.year!]))
            .appendingPathComponent(String(format: "%02d", arguments: [date.month!]))
            .appendingPathComponent(formatter.string(from: date.date!))
            .appendingPathExtension("markdown")
    }

    func entries() throws -> [Worklog] {
        return try FileManager.default.subpathsOfDirectory(atPath: worklogPath.path) // [String]
            .map { worklogPath.appendingPathComponent($0) } // URL
            .filter { ["markdown", "md"].contains($0.pathExtension) }
            .map { try Worklog(path: $0) }
            // TODO Add better check for this
            .filter { $0.frontmatter.date != nil }
    }
}
