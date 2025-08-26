//
//  PriceQuote.swift
//  BTCPriceCore
//
//  Created by Juan Francisco Dorado Torres on 25/08/25.
//

import Foundation

public struct PriceQuote: Equatable, Sendable {
  public let value: Decimal
  public let currency: String
  public let timestamp: Date

  public init(value: Decimal, currency: String, timestamp: Date) {
    self.value = value
    self.currency = currency
    self.timestamp = timestamp
  }
}
