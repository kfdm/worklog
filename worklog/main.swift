//
//  main.swift
//  worklog
//
//  Created by ST20638 on 2019/10/16.
//  Copyright © 2019 ST20638. All rights reserved.
//

import SwiftCLI

let main = CLI(name: "worklog", version: "1.0.0", description: "Tool for managing a hugo based worklog")
main.commands = [NewCommand(), ServerCommand(), ConfigCommand()]
main.goAndExit()
