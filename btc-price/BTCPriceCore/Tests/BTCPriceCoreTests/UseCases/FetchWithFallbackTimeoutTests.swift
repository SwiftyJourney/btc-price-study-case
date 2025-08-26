//
//  FetchWithFallbackTimeoutTests.swift
//  BTCPriceCore
//
//  Created by Juan Francisco Dorado Torres on 25/08/25.
//

import BTCPriceCore
import Foundation
import Testing

@Suite("FetchWithFallback + Timeout")
struct Test {
  @Test
  func usesPrimary_whenPrimaryFinishesBeforeTimeout() async throws {
    let expected = PriceQuote(
      value: 68_900,
      currency: "USD",
      timestamp: Date()
    )
    let primary = ClosureLoader { expected }
    let fallback = ClosureLoader { throw DummyError.any }

    let sut = FetchWithFallback(
      primary: primary,
      fallback: fallback,
      timeout: 1,
      clock: TestClock()
    )

    let received = try await sut.execute()

    #expect(received == expected)
  }

  // MARK: - Helpers

  struct ClosureLoader: PriceLoader {
    let action: @Sendable () async throws -> PriceQuote
    func loadLatest() async throws -> PriceQuote { try await action() }
  }

  private enum DummyError: Error { case any }

  private struct TestClock: Clock {
    var nowValue: Date = .init()

    func now() -> Date {
      nowValue
    }

    func sleep(for seconds: TimeInterval) async {
      // No-op: no sleep on tests
    }
  }
}
