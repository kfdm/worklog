//
//  New.swift
//  worklog
//
//  Created by Paul Traylor on 2019/10/17.
//  Copyright © 2019 Paul Traylor. All rights reserved.
//

import Foundation
import SwiftCLI
import Rainbow

class NewCommand: Command {
    let name = "new"
    let path = Parameter()
    func execute() throws {
        stdout <<< "Creating new hugo site".yellow
        let base = URL(fileURLWithPath: path.value)

        try shell("hugo", "new", "site", "--format", "yaml", base.path)
        _ = Process.changeCurrentDirectoryPath(base)

        stdout <<< "Checking out themes".yellow
        try shell("git", "init")
        try shell("git", "submodule", "add", "https://github.com/Xzya/hugo-bootstrap.git", "themes/bootstrap")
        try shell("git", "submodule", "add", "https://github.com/kfdm/hugo-worklog", "themes/worklog")

        stdout <<< "Configuring Theme".yellow

        var config = try RawConfig.load(path: base.appendingPathComponent("config.yaml"))
        config!["theme"] = ["bootstrap", "worklog"]
        try config?.dump(path: "config.yaml")
    }
}
