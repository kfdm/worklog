//
//  SwiftCLI+Extensions.swift
//  worklog
//
//  Created by ST20638 on 2019/10/17.
//  Copyright © 2019 ST20638. All rights reserved.
//

import SwiftCLI
import Foundation

extension Command {
    func shellStatus(args: [String]) -> Int32 {
        let task = Process()
        task.standardOutput = stdout.writeHandle
        task.standardError = stderr.writeHandle
        task.launchPath = "/usr/bin/env"
        task.arguments = args
        task.launch()
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
