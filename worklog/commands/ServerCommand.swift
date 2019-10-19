//
//  Server.swift
//  worklog
//
//  Created by Paul Traylor on 2019/10/17.
//  Copyright © 2019 Paul Traylor. All rights reserved.
//

import SwiftCLI

class ServerCommand: Command {
    let name = "server"
    func execute() throws {
        try shell("hugo", "server", "--buildDrafts", "--buildFuture")
    }
}
