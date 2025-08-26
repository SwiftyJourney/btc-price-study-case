//
//  FetchLatestPrice.swift
//  BTCPriceCore
//
//  Created by Juan Francisco Dorado Torres on 25/08/25.
//

import Foundation

public struct FetchLatestPrice {
  private let loader: PriceLoader

  public init(loader: PriceLoader) {
    self.loader = loader
  }

  public func execute() async throws -> PriceQuote {
    try await loader.loadLatest()
  }
}
