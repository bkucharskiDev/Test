//
// Copyright (©) 2018 AirHelp. All rights reserved.
//

import Foundation

public class NotMatcher: MockEquatable {
    private let containedMatcher: MockEquatable

    public init(containedMatcher: MockEquatable) {
        self.containedMatcher = containedMatcher
    }

    public func equalTo(other: Any?) -> Bool {
        return !containedMatcher.equalTo(other: other)
    }

    public var description: String {
        return "\(type(of: self)) - \(containedMatcher)"
    }
}
