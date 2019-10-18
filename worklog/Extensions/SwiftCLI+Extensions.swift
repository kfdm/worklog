//
//  SwiftCLI+Extensions.swift
//  worklog
//
//  Created by ST20638 on 2019/10/17.
//  Copyright © 2019 ST20638. All rights reserved.
//

import SwiftCLI
import Foundation
import os

private var task: Process!

extension Process {
    func throwOnError() throws {
        waitUntilExit()
        if terminationStatus != 0 {
            throw CLI.Error.init(exitStatus: terminationStatus)
        }
    }
}

extension Command {
    func changeCurrentDirectoryPath(_ path: String) -> Bool {
        return FileManager().changeCurrentDirectoryPath(path)
    }

    func shell(_ args: String...) throws {
        os_log(.debug, "Launching %s", args)
        task = Process()
        task.launchPath = "/usr/bin/env"
        task.standardOutput = stdout.writeHandle
        task.standardError = stderr.writeHandle
        task.arguments = args
        task.launch()

        signal(SIGINT) { _ in task.interrupt() }
        signal(SIGTERM) { _ in task.terminate() }

        try task.throwOnError()
    }
}
