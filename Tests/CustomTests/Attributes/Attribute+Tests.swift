//
//  Attribute+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 05/11/2025.
//

@testable import Custom
import Testing

struct AttributeTests {
    typealias Mock = Attribute<Mod>
    typealias Mod = MockModifier<Int>

    @Test("Creates a new attribute", arguments: [
        (23, [Mod(12)], 12)
    ])
    func initializer(wrappedValue: Int, modifiers: [Mod], previewValue: Int) {
        let sut = Mock(wrappedValue: wrappedValue, modifiers: modifiers)
        #expect(sut.base == wrappedValue)
        #expect(sut.modifiers == modifiers)
        #expect(sut.wrappedValue == previewValue)
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

    @Test("Sets the raw value for an attribute", arguments: [
        (Mock(wrappedValue: 12), 8, 8),
        (Mock(wrappedValue: 12, modifiers: [Mod(47)]), 43, 43)
    ])
    func wrappedValue(set sut: Mock, newValue: Int, expected: Int) {
        var sut = sut
        sut.wrappedValue = newValue
        #expect(sut.wrappedValue == expected)
        #expect(sut.modifiers.isEmpty)
    }

    @Test("Applies all modifiers to the base value, clearing modifiers", arguments: [
        (Mock(wrappedValue: 12, modifiers: [Mod(47)]), Mock(wrappedValue: 47)),
        (Mock(wrappedValue: 12), Mock(wrappedValue: 12))
    ])
    func merge(_ sut: Mock, expected: Mock) {
        var sut = sut
        sut.merge()
        #expect(sut == expected)
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

    // MARK: Self: ExpressibleByFloatLiteral
    struct ConformsToExpressibleByFloatLiteral {
        typealias DoubleMock = Attribute<MockModifier<Double>>

        @Test("Creates an attribute for modifier", arguments: [
            (23.4, DoubleMock(wrappedValue: 23.4))
        ])
        func initializer(floatLiteral value: Double, expected: DoubleMock) {
            let result = DoubleMock(floatLiteral: value)
            #expect(result == expected)
        }
    }

    // MARK: Self: ExpressibleByIntegerLiteral
    struct ConformsToExpressibleByIntegerLiteral {
        typealias Mock = Attribute<MockModifier<Int>>

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
        typealias Mock = Attribute<MockModifier<Int?>>

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
