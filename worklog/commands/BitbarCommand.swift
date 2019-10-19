//
//  BitbarCommand.swift
//  worklog
//
//  Created by Paul Traylor on 2019/10/19.
//  Copyright © 2019 Paul Traylor. All rights reserved.
//

import SwiftCLI
import Foundation

class BitbarInstallCommand: Command {
    let name = "install"
    let shortDescription = "Install BitBar support"

    func execute() throws {
        guard let bitbar = UserDefaults.init(suiteName: "com.matryer.BitBar") else {
            throw CLI.Error(message: "Bitbar not found")
        }
        guard let pluginDirectory =  bitbar.string(forKey: "pluginsDirectory") else {
            throw CLI.Error(message: "Unable to find Plugin Directory")
        }
        print(pluginDirectory)
    }
}

class BitbarRunCommand: Command {
    let name = "run"
    func execute() throws {
        throw CLI.Error(message: "Not yet implemented")
    }
}

class BitbarGroup: CommandGroup {
    let name = "bitbar"
    let shortDescription = "Support for Bitbar"
    let children: [Routable] = [BitbarInstallCommand(), BitbarRunCommand()]
}
