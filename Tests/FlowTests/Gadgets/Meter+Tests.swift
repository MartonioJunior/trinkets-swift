//
//  Meter+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 16/07/2025.
//

@testable import Flow
import Testing

struct MeterTests {
    func syntax() {
        @Meter(f: 3...) var a
        @Meter(c: ...9) var b
        @Meter(c: ..<8) var c
        @Meter(f: 5..<12) var d
        @Meter(2...5) var e = 4
    }
}
