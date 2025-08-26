//
//  Clock.swift
//  BTCPriceCore
//
//  Created by Juan Francisco Dorado Torres on 25/08/25.
//

import Foundation

public protocol Clock: Sendable {
  func now() -> Date
  func sleep(for seconds: TimeInterval) async
}

public struct SystemClock: Clock {
  public init() {}

  public func now() -> Date {
    Date()
  }

  public func sleep(for seconds: TimeInterval) async {
    try? await Task.sleep(nanoseconds: .init(seconds * 1_000_000_000))
  }
}
