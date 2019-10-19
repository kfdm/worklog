//
//  Config.swift
//  worklog
//
//  Created by ST20638 on 2019/10/17.
//  Copyright © 2019 ST20638. All rights reserved.
//

import Foundation
import Yams

struct HugoConfig: Codable {
    var theme: [String]?
}

struct WorklogConfig: Codable {
    var basePath: URL
}

extension WorklogConfig {
    func filename(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date) + ".markdown"
    }
    func entry(for date: Date) -> URL {
        return entry(date: Calendar.current.dateComponents(in: .current, from: date))
    }
    func entry(date: DateComponents) -> URL {
        return basePath
            .appendingPathComponent("content")
            .appendingPathComponent("worklog")
            .appendingPathComponent(String(format: "%04d", arguments: [date.year!]))
            .appendingPathComponent(String(format: "%02d", arguments: [date.month!]))
            .appendingPathComponent(filename(from: date.date!))
    }

    var hugoConfig: HugoConfig {
        let configPath = basePath
            .appendingPathComponent("config.yaml")
        let configYaml = try! String(contentsOf: configPath, encoding: .utf8)
        return try! YAMLDecoder().decode(HugoConfig.self, from: configYaml, userInfo: [:])
    }
}

typealias RawConfig = [String: Any]

extension RawConfig {
    static func load(path: URL) throws -> RawConfig? {
        let inputYaml = try String(contentsOfFile: path.path)
        return try (Yams.load(yaml: inputYaml) as? [String: Any])
    }

    func dump(path: String) throws {
        let outputYaml: String = try Yams.dump(object: self)
        try outputYaml.write(toFile: path, atomically: true, encoding: .utf8)
    }
}
