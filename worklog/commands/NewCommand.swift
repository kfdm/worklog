//
//  New.swift
//  worklog
//
//  Created by ST20638 on 2019/10/17.
//  Copyright © 2019 ST20638. All rights reserved.
//

import SwiftCLI
import Yams
import Rainbow

class NewCommand: Command {
    let name = "new"
    let path = Parameter()
    func execute() throws {
        stdout <<< "Creating new hugo site".yellow
        try shell("hugo", "new", "site", "--format", "yaml", path.value)
        changeCurrentDirectoryPath(path.value)

        stdout <<< "Checking out themes".yellow
        try shell("git", "init")
        try shell("git", "submodule", "add", "https://github.com/Xzya/hugo-bootstrap.git", "themes/bootstrap")
        try shell("git", "submodule", "add", "https://github.com/kfdm/hugo-worklog", "themes/worklog")

        stdout <<< "Configuring Theme".yellow
        var config = try RawConfig.load(path: "config.yaml")
        config!["theme"] = ["bootstrap", "worklog"]
        try config?.dump(path: "config.yaml")
    }
}
