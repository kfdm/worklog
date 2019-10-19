//
//  Config.swift
//  worklog
//
//  Created by Paul Traylor on 2019/10/17.
//  Copyright © 2019 Paul Traylor. All rights reserved.
//

import Foundation
import SwiftCLI
import Yams

class ConfigCommand: Command {
    let name = "config"

    func execute() throws {
        var basePath = UserDefaults.shared.path(for: .worklog)!
        basePath.appendPathComponent("config.yaml")
        print(basePath)
        let config = try RawConfig.load(path: basePath)!
        print(config.debugDescription)
    }
}
