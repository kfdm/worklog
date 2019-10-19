//
//  Config.swift
//  worklog
//
//  Created by Paul Traylor on 2019/10/19.
//  Copyright © 2019 Paul Traylor. All rights reserved.
//

import Foundation
import Yams


struct HugoConfig: Codable {
    var theme: [String]?
}

extension HugoConfig {
    static func load(from path: URL) throws -> HugoConfig {
        let configYaml = try String(contentsOf: path)
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
