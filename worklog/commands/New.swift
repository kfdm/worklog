//
//  New.swift
//  worklog
//
//  Created by ST20638 on 2019/10/17.
//  Copyright © 2019 ST20638. All rights reserved.
//

import SwiftCLI

class NewCommand: Command {
    let name = "new"
    let path = Parameter()
    func execute() throws {
        stdout <<< "Creating new hugo site"
        try shell("hugo", "new", "site", path.value)
        stdout <<< "Checking out themes"
        try shell("git", "init")
        try shell("git", "submodule", "add", "https://github.com/budparr/gohugo-theme-ananke.git", "themes/ananke")
    }
}
