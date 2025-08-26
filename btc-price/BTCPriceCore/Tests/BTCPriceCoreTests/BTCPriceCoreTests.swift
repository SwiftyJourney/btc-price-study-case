import BTCPriceCore
import Foundation
import Testing

struct LoaderStub: PriceLoader {
  let result: Result<PriceQuote, Error>
  func loadLatest() async throws -> PriceQuote { try result.get() }
}

@Test func fetchLatestPrice_deliversValueFromLoader() async throws {
  let expected = PriceQuote(
    value: 68_901.23,
    currency: "USD",
    timestamp: Date()
  )

  let sut = FetchLatestPrice(loader: LoaderStub(result: .success(expected)))

  let received = try await sut.execute()

  #expect(received == expected)
}
