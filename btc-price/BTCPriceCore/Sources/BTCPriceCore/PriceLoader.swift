//
//  PriceLoader.swift
//  BTCPriceCore
//
//  Created by Juan Francisco Dorado Torres on 25/08/25.
//

import Foundation

public protocol PriceLoader {
  func loadLatest() async throws -> PriceQuote
}
