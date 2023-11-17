//
//  Atomic.swift
//  PauseParenting
//
//  Created by Dmytro Savka on 20.10.2023.
//

import Foundation

@propertyWrapper
struct Atomic<Value> {
    private var value: Value
    private let lock = NSLock()

    init(wrappedValue value: Value) {
        self.value = value
    }

    var wrappedValue: Value {
      get { return load() }
      set { store(newValue: newValue) }
    }

    func load() -> Value {
        lock.withLock {
            return value
        }
    }

    mutating func store(newValue: Value) {
        lock.withLock {
            value = newValue
        }
    }
}
