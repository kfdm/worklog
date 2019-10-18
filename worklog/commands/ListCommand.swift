//
//  ListCommand.swift
//  worklog
//
//  Created by ST20638 on 2019/10/18.
//  Copyright © 2019 ST20638. All rights reserved.
//

import SwiftCLI

class ListFutureCommand: Command {
    let name = "future"
    let shortDescription = "List all posts dated in the future"

    func execute() throws {
        try shell("hugo", "list", "future")
    }
}

class ListGroup: CommandGroup {
    let name = "list"
    let shortDescription = "Listing out various types of content."
    let children: [Routable] = [ListFutureCommand()]
}
