//
//  Defaults+Extensions.swift
//  worklog
//
//  Created by ST20638 on 2019/10/18.
//  Copyright © 2019 ST20638. All rights reserved.
//

import Foundation

enum UserKeys: String {
    case worklog
}

extension UserDefaults {
    static var shared = UserDefaults(suiteName: "net.kungfudiscomonkey.worklog")!

    func path(for lookup: UserKeys, default defaultPath: String = FileManager.default.currentDirectoryPath) -> URL? {
        return url(forKey: lookup.rawValue) ?? URL(fileURLWithPath: defaultPath)
    }
}
