//
//  FetchWithFallback.swift
//  BTCPriceCore
//
//  Created by Juan Francisco Dorado Torres on 25/08/25.
//

import Foundation

public struct FetchWithFallback: Sendable {
  private let primary: PriceLoader
  private let fallback: PriceLoader
  private let timeout: TimeInterval?
  private let clock: Clock?

  public init(primary: PriceLoader, fallback: PriceLoader) {
    self.primary = primary
    self.fallback = fallback
    self.timeout = nil
    self.clock = nil
  }

  public init(primary: PriceLoader, fallback: PriceLoader, timeout: TimeInterval, clock: Clock) {
    self.primary = primary
    self.fallback = fallback
    self.timeout = timeout
    self.clock = clock
  }

  public func execute() async throws -> PriceQuote {
    guard let timeout, let clock else {
      do {
        return try await primary.loadLatest()
      } catch {
        return try await fallback.loadLatest()
      }
    }

    return try await withThrowingTaskGroup(of: PriceQuote.self) { group in
      group.addTask { @Sendable in
        try await primary.loadLatest()
      }

      group.addTask { @Sendable in
        await clock.sleep(for: timeout)

        struct TimeoutError: Error {}
        throw TimeoutError()
      }

      do {
        let quote = try await group.next()!
        group.cancelAll()
        return quote
      } catch {
        group.cancelAll()
        return try await fallback.loadLatest()
      }
    }
  }
}
