//
//  Server.swift
//  worklog
//
//  Created by ST20638 on 2019/10/17.
//  Copyright © 2019 ST20638. All rights reserved.
//

import SwiftCLI

class ServerCommand: Command {
    let name = "server"
    func execute() throws {
        try shell("hugo", "server", "--buildDrafts", "--buildFuture")
    }
}
