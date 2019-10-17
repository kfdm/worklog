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
        let inputYaml = try String(contentsOfFile: "config.yaml")
        var loadedDictionary = try Yams.load(yaml: inputYaml) as? [String: Any]
        stdout <<< loadedDictionary.debugDescription
    }
}
