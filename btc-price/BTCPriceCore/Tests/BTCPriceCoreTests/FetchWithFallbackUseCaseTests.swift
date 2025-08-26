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

  // MARK: - Helpers

  struct ClosureLoader: PriceLoader {
    let action: () async throws -> PriceQuote
    func loadLatest() async throws -> PriceQuote { try await action() }
  }

  private enum DummyError: Error { case any }
}
