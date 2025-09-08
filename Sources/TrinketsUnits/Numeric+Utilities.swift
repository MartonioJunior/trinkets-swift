//
//  Numeric+Utilities.swift
//  Trinkets
//
//  Created by Martônio Júnior on 13/08/2025.
//

public extension Numeric {
    var negated: Self { .zero - self }
}

// MARK: Global
func loopPow<N: Numeric>(_ x: N, e n: Int) -> N {
    (0..<n).reduce(1) { acc, _ in acc * x }
}

func loopRoot<N: Numeric>(_ x: N, n exponent: Int) -> N where N: Comparable {
    let e = 1 / exponent
    let negativeNumber = x < 0
    let isOddNumber = abs(exponent % 2) == 1

    return if negativeNumber && isOddNumber {
        loopPow(x.negated, e: e).negated
    } else {
        loopPow(x, e: e)
    }
}
