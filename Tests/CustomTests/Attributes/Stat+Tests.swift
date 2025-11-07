//
//  Stat+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 05/11/2025.
//

@testable import Custom
import Testing

struct StatTests {
    typealias Mod = MockModifier<Int>
    typealias Mock = Stat<Mod>

    @Test("Creates a new Stat")
    func initializer() {
        let sut = Mock(wrappedValue: 5, modifiers: [])
        let expected = Attribute<Mod>(wrappedValue: 5, modifiers: [])
        #expect(sut.attribute == expected)
    }

    @Test("Returns the raw value for an attribute", arguments: [
        (Mock(wrappedValue: 12), 12),
        (Mock(wrappedValue: 12, modifiers: [Mod(47)]), 12)
    ])
    func base(get sut: Mock, expected: Int) {
        #expect(sut.base == expected)
    }

    @Test("Sets the raw value for an attribute", arguments: [
        (Mock(wrappedValue: 12), 8, 8),
        (Mock(wrappedValue: 12, modifiers: [Mod(47)]), 43, 43)
    ])
    func base(set sut: Mock, newValue: Int, expected: Int) {
        var sut = sut
        sut.base = newValue
        #expect(sut.base == expected)
    }

    @Test("Returns the attribute instance", arguments: [
        (Mock(wrappedValue: 89))
    ])
    func projectedValue(get sut: Mock) {
        #expect(sut.projectedValue == sut)
    }

    @Test("Returns the attribute instance", arguments: [
        (Mock(wrappedValue: 89), Mock(wrappedValue: 90))
    ])
    func projectedValue(set sut: Mock, newValue: Mock) {
        var sut = sut
        sut.projectedValue = newValue
        #expect(sut.projectedValue == newValue)
    }

    @Test("Returns the raw value for an attribute", arguments: [
        (Mock(wrappedValue: 12), 12),
        (Mock(wrappedValue: 12, modifiers: [Mod(47)]), 47)
    ])
    func wrappedValue(get sut: Mock, expected: Int) {
        #expect(sut.wrappedValue == expected)
    }

    @Test("Updates the attribute with a new value, clearing modifiers", arguments: [
        (Mock(wrappedValue: 12), 8, Mock(wrappedValue: 8)),
        (Mock(wrappedValue: 12, modifiers: [Mod(47)]), 43, Mock(wrappedValue: 43))
    ])
    func overwrite(_ sut: Mock, newValue: Int, expected: Mock) {
        var sut = sut
        sut.overwrite(newValue)
        #expect(sut == expected)
    }

    // MARK: Self: Customizable
    struct ConformsToCustomizable {
        @Test("Returns the modifiers in the stat", arguments: [
            (Mock(wrappedValue: 12, modifiers: [Mod(47)]), [Mod(47)])
        ])
        func modifiers(_ sut: Mock, expected: [Mod]) {
            #expect(sut.modifiers == expected)
        }
    }

    // MARK: Self: ExpressibleByFloatLiteral
    struct ConformsToExpressibleByFloatLiteral {
        typealias Mock = Stat<MockModifier<Double>>

        @Test("Creates a stat for modifier", arguments: [
            (23.4, Mock(wrappedValue: 23.4))
        ])
        func initializer(floatLiteral value: Double, expected: Mock) {
            let result = Mock(floatLiteral: value)
            #expect(result == expected)
        }
    }

    // MARK: Self: ExpressibleByIntegerLiteral
    struct ConformsToExpressibleByIntegerLiteral {
        typealias Mock = Stat<MockModifier<Int>>

        @Test("Creates an attribute for modifier", arguments: [
            (45, Mock(wrappedValue: 45))
        ])
        func initializer(integerLiteral value: Int, expected: Mock) {
            let result = Mock(integerLiteral: value)
            #expect(result == expected)
        }
    }

    // MARK: Self: ExpressibleByNilLiteral
    struct ConformsToExpressibleByNilLiteral {
        typealias Mock = Stat<MockModifier<Int?>>

        @Test("Creates an attribute for modifier")
        func initializer() {
            let result = Mock(nilLiteral: ())
            #expect(result == Mock(wrappedValue: nil))
        }
    }

    // MARK: Self: Modifiable
    struct ConformsToModifiable {
        @Test("Adds a modifier to the Attribute", arguments: [
            (Mock(wrappedValue: 23), Mod(45), Mock(wrappedValue: 23, modifiers: [Mod(45)])),
            (Mock(wrappedValue: 23, modifiers: [Mod(81)]), Mod(11), Mock(wrappedValue: 23, modifiers: [Mod(81), Mod(11)]))
        ])
        func apply(_ sut: Mock, _ modifier: Mod, expected: Mock) {
            var sut = sut
            sut.apply(modifier)
            #expect(sut == expected)
        }

        @Test("Adds a modifier to the Attribute", arguments: [
            (Mock(wrappedValue: 23), Mock(wrappedValue: 23)),
            (Mock(wrappedValue: 23, modifiers: [Mod(81)]), Mock(wrappedValue: 23, modifiers: [Mod(81)])),
            (Mock(wrappedValue: 23, modifiers: [Mod(42), Mod(77)]), Mock(wrappedValue: 23, modifiers: [Mod(77)]))
        ])
        func clearModifiers(_ sut: Mock, expected: Mock) {
            var sut = sut
            sut.clearModifiers { $0.value.isMultiple(of: 2) }
            #expect(sut == expected)
        }

        @Test("Adds a modifier to the Attribute", arguments: [
            (Mock(wrappedValue: 23), Mock(wrappedValue: 23)),
            (Mock(wrappedValue: 23, modifiers: [Mod(81)]), Mock(wrappedValue: 23)),
            (Mock(wrappedValue: 23, modifiers: [Mod(42), Mod(77)]), Mock(wrappedValue: 23))
        ])
        func clearAllModifiers(_ sut: Mock, expected: Mock) {
            var sut = sut
            sut.clearAllModifiers()
            #expect(sut == expected)
        }
    }
}
