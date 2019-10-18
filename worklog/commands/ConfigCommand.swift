//
//  Config.swift
//  worklog
//
//  Created by ST20638 on 2019/10/17.
//  Copyright © 2019 ST20638. All rights reserved.
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
        let config = try RawConfig.load(path: basePath)
        print(config)
    }
}
