//
//  NSObjectProtocol+Additions.swift
//  EffectiveToDo
//
//  Created by Мария Изюменко on 25.08.2024.
//

import Foundation

extension NSObjectProtocol {
    @inlinable
    @inline(__always)
    @discardableResult
    func applying(_ apply: (Self) -> Void) -> Self {
        apply(self)
        return self
    }
}
