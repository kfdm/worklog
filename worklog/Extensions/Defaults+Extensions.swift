//
//  Defaults+Extensions.swift
//  worklog
//
//  Created by Paul Traylor on 2019/10/18.
//  Copyright © 2019 Paul Traylor. All rights reserved.
//

import Foundation

enum UserKeys: String {
    case domain = "net.kungfudiscomonkey.worklog"
    case worklog
}

extension UserDefaults {
    static var shared = UserDefaults(suiteName: UserKeys.domain.rawValue)!

    func path(for lookup: UserKeys, default defaultPath: String = FileManager.default.currentDirectoryPath) -> URL? {
        return url(forKey: lookup.rawValue) ?? URL(fileURLWithPath: defaultPath)
    }
}
