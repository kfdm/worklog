//
//  SwiftCLI+Extensions.swift
//  worklog
//
//  Created by Paul Traylor on 2019/10/17.
//  Copyright © 2019 Paul Traylor. All rights reserved.
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
    static func changeCurrentDirectoryPath(_ path: URL) -> Bool {
        return FileManager.default.changeCurrentDirectoryPath(path.path)
    }
}

extension Command {
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
