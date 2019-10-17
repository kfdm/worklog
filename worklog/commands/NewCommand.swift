//
//  New.swift
//  worklog
//
//  Created by ST20638 on 2019/10/17.
//  Copyright © 2019 ST20638. All rights reserved.
//

import SwiftCLI
import Yams

class NewCommand: Command {
    let name = "new"
    let path = Parameter()
    func execute() throws {
        stdout <<< "Creating new hugo site"
        try shell("hugo", "new", "site", "--format", "yaml", path.value)
        changeCurrentDirectoryPath(path.value)

        stdout <<< "Checking out themes"
        try shell("git", "init")
        try shell("git", "submodule", "add", "https://github.com/Xzya/hugo-bootstrap.git", "themes/bootstrap")
        try shell("git", "submodule", "add", "https://github.com/kfdm/hugo-worklog", "themes/worklog")
        
        stdout <<< "Configuring Theme"
        let inputYaml = try String(contentsOfFile: "config.yaml")
        var loadedDictionary = try Yams.load(yaml: inputYaml) as? [String: Any]
        loadedDictionary!["theme"] = ["bootstrap", "worklog"]
        let outputYaml: String = try Yams.dump(object: loadedDictionary)
        try outputYaml.write(toFile: "config.yaml", atomically: true, encoding: .utf8)
    }
}
