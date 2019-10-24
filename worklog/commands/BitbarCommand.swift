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
        let scriptPath = URL(fileURLWithPath: pluginDirectory)
            .appendingPathComponent("worklog.5m.sh")
        let command = ProcessInfo.processInfo.arguments.first!
        let script = "#!/bin/sh\nexec \(command) bitbar run"
        try script.write(to: scriptPath, atomically: true, encoding: .utf8)
        try FileManager.default.setAttributes([.posixPermissions: 0o755], ofItemAtPath: scriptPath.path)
    }
}

class BitbarRunCommand: Command {
    let name = "run"
    func execute() throws {
        stdout <<< ":pencil:"
        stdout <<< "---"
        stdout <<< "RELOAD | refresh=true"
        stdout <<< "---"

        try Hugo.default.entries()
            .sorted { $0.path.path > $1.path.path }
            .prefix(10)
            .forEach({ (wl) in
                stdout <<< "\(wl.frontmatter.title) | href=\"\(wl.path.description)\""
        })
    }
}

class BitbarGroup: CommandGroup {
    let name = "bitbar"
    let shortDescription = "Support for Bitbar"
    let children: [Routable] = [BitbarInstallCommand(), BitbarRunCommand()]
}
