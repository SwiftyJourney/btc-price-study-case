//
//  FetchWithFallbackUseCaseTests.swift
//  BTCPriceCore
//
//  Created by Juan Francisco Dorado Torres on 25/08/25.
//

import BTCPriceCore
import Foundation
import Testing

@Suite("FetchWithFallbackUseCaseTests")
struct FetchWithFallbackUseCaseTests {
  @Test
  func fetchWithFallback_usesPrimaryOnSuccess() async throws {
    let expected = PriceQuote(
      value: 68_900,
      currency: "USD",
      timestamp: Date()
    )

    let primary = ClosureLoader { expected }
    let fallback = ClosureLoader { throw DummyError.any }

    let sut = FetchWithFallback(primary: primary, fallback: fallback)

    let received = try await sut.execute()

    #expect(received == expected)
  }

  @Test
  func fetchWithFallback_usesFallbackWhenPrimaryFails() async throws {
    let expected = PriceQuote(
      value: 68_850,
      currency: "USD",
      timestamp: Date()
    )

    let primary = ClosureLoader { throw DummyError.any }
    let fallback = ClosureLoader { expected }

    let sut = FetchWithFallback(primary: primary, fallback: fallback)

    let received = try await sut.execute()

    #expect(received == expected)
  }

  @Test
  func fetchWithFallback_throwsWhenBothFail() async throws {
    let primary = ClosureLoader { throw DummyError.any }
    let fallback = ClosureLoader { throw DummyError.any }

    let sut = FetchWithFallback(primary: primary, fallback: fallback)

    await #expect(throws: Error.self) {
      _ = try await sut.execute()
    }
  }

  // MARK: - Helpers

  struct ClosureLoader: PriceLoader {
    let action: @Sendable () async throws -> PriceQuote
    func loadLatest() async throws -> PriceQuote { try await action() }
  }

  private enum DummyError: Error { case any }
}
