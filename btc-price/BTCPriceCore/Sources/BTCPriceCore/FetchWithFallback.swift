//
//  FetchWithFallback.swift
//  BTCPriceCore
//
//  Created by Juan Francisco Dorado Torres on 25/08/25.
//

import Foundation

public struct FetchWithFallback {
  private let primary: PriceLoader
  private let fallback: PriceLoader

  public init(primary: PriceLoader, fallback: PriceLoader) {
    self.primary = primary
    self.fallback = fallback
  }

  public func execute() async throws -> PriceQuote {
    do {
      return try await primary.loadLatest()
    } catch {
      return try await fallback.loadLatest()
    }
  }
}
