//
//  Amount+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 07/01/2026.
//

@testable import TrinketsUnits
import Testing

struct AmountTests {
    @Test("Creates new unit for quantity", arguments: [
        ("websites", Unit<Amount>("websites"))
    ])
    func of(
        _ symbol: String,
        expected: Unit<Amount>
    ) {
        let resultA = Amount[dynamicMember: symbol.description]
        let resultB = Amount.of(symbol.description)

        #expect(resultA == expected)
        #expect(resultB == expected)
    }

    @Test("Base unit is 'units'")
    func baseUnit() {
        #expect(Amount.baseUnit == Unit<Amount>("units"))
    }

    @Test("It's a dimensionless unit")
    func dimensionality() {
        #expect(Amount.dimensionality == Dimensionality.dimensionless)
    }

    @Test("Returns the value passed in", arguments: [
        (5.3, Amount.lollipops, 5.3)
    ])
    func baseValue(
        of value: Double,
        _ unit: Unit<Amount>,
        expected: Double
    ) {
        let result = Amount.baseValue(of: value, unit)
        #expect(expected == result)
    }

    @Test("Returns nan", arguments: [
        (4.1, Amount.goals)
    ])
    func convert(
        _ value: Double,
        to unit: Unit<Amount>
    ) {
        let result = Amount.convert(value, to: unit)
        #expect(result.isNaN)
    }
}

// MARK: Unit (EX)
extension UnitTests {
    @Test("Creates unit with compile-time symbol")
    func auto() {
        let refString: StaticString = #file
        let result = Unit<Amount>.auto(refString)
        #expect(result == Unit<Amount>(refString.description))
    }
}
