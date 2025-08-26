import BTCPriceCore
import Foundation
import Testing

@Suite("FetchLatestPriceUseCaseTests")
struct FetchLatestPriceUseCaseTests {
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

  @Test
  func fetchLatestPrice_propagatesLoaderError() async {
    let sut = FetchLatestPrice(loader: LoaderStub(result: .failure(DummyError.any)))

    await #expect(throws: Error.self) {
      _ = try await sut.execute()
    }
  }

  // MARK: - Helpers

  private struct LoaderStub: PriceLoader {
    let result: Result<PriceQuote, Error>
    func loadLatest() async throws -> PriceQuote { try result.get() }
  }

  private enum DummyError: Error { case any }
}
