//
//  Frontmatter.swift
//  worklog
//
//  Created by Paul Traylor on 2019/10/24.
//  Copyright © 2019 Paul Traylor. All rights reserved.
//

import Foundation
import Yams

typealias Frontmatter = [String: Any]

extension Frontmatter {
    var date: String? {
        get {
            return self["date"] as? String
        }
        set {
            self["date"] = newValue
        }
    }

    var title: String {
        get {
            return self["title"] as! String
        }
        set {
            self["title"] = newValue
        }
    }

    init(from: String) {
        self = try! Yams.load(yaml: from) as! Frontmatter
    }

    var raw: String {
        return try! Yams.dump(object: self)
    }
}
