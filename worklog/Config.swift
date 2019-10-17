//
//  Config.swift
//  worklog
//
//  Created by ST20638 on 2019/10/17.
//  Copyright © 2019 ST20638. All rights reserved.
//

import Foundation
import Yams

struct Config: Codable {
    var theme: [String]?
}

typealias RawConfig = [String: Any]

extension RawConfig {
    static func load(path: String) throws -> RawConfig? {
        let inputYaml = try String(contentsOfFile: "config.yaml")
        return try (Yams.load(yaml: inputYaml) as? [String: Any])
    }

    func dump(path: String) throws {
        let outputYaml: String = try Yams.dump(object: self)
        try outputYaml.write(toFile: path, atomically: true, encoding: .utf8)
    }
}
