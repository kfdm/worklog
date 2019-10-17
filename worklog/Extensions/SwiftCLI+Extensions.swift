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

extension Command {
    func changeCurrentDirectoryPath(_ path: String) -> Bool {
        return FileManager().changeCurrentDirectoryPath(path)
    }

    func shellStatus(args: [String]) -> Int32 {
        os_log(.debug, "Launching %s", args)
        task = Process()
        task.launchPath = "/usr/bin/env"
        task.standardOutput = stdout.writeHandle
        task.standardError = stderr.writeHandle
        task.arguments = args
        task.launch()

        signal(SIGINT) { _ in task.interrupt() }
        signal(SIGTERM) { _ in task.terminate() }

        task.waitUntilExit()
        return task.terminationStatus
    }
    func shell(_ args: String...) throws {
        let return_code = shellStatus(args: args)
        if return_code != 0 {
            throw CLI.Error.init(exitStatus: return_code)
        }
    }

}
