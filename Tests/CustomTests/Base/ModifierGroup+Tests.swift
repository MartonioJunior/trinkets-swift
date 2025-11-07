//
//  ModifierGroup+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 05/11/2025.
//

@testable import Custom
import Testing

struct ModifierGroupTests {
    typealias Mock = ModifierGroup<Mod>
    typealias Mod = MockModifier<Int>

    @Test("Creates a new modifier group", arguments: [
        ([Mod]()),
        ([Mod(23), Mod(35)])
    ])
    func initializers(_ modifiers: [Mod]) {
        let sut = Mock(modifiers)
        #expect(sut.modifiers == modifiers)
    }

    // MARK: Self: ExpressibleByArrayLiteral
    struct ConformsToExpressibleByArrayLiteral {
        @Test("Creates group with modifiers")
        func initializer() {
            let result = ModifierGroup(arrayLiteral: Mod(5), Mod(7), Mod(1))
            let expected = ModifierGroup([Mod(5), Mod(7), Mod(1)])
            #expect(result == expected)
        }
    }

    // MARK: Self: Modifier
    struct ConformsToModifier {
        @Test("Applies modifier group to the target", arguments: [
            (Mock([Mod(11), Mod(14), Mod(12)]), 23, 12)
        ])
        func apply(_ sut: Mock, to target: Mod.Target, expected: Mod.Target) {
            var target = target
            sut.apply(to: &target)
            #expect(target == expected)
        }
    }

    // MARK: Self: Modifiable
    struct ConformsToModifiable {
        @Test("Adds a modifier to the group", arguments: [
            (Mock([Mod(12)]), Mod(21), Mock([Mod(12), Mod(21)]))
        ])
        func apply(_ sut: Mock, _ modifier: Mod, expected: Mock) {
            var sut = sut
            sut.apply(modifier)
            #expect(sut == expected)
        }

        @Test("Removes all modifiers that fit the given criteria", arguments: [
            (Mock([Mod(13), Mod(25)]), Mock([])),
            (Mock([Mod(12), Mod(21)]), Mock([Mod(12)]))
        ])
        func clearModifiers(_ sut: Mock, expected: Mock) {
            var sut = sut
            sut.clearModifiers { !$0.value.isMultiple(of: 2) }
            #expect(sut == expected)
        }

        @Test("Removes all modifiers from the group", arguments: [
            (Mock([Mod(13), Mod(25)]), Mock())
        ])
        func clearAllModifiers(_ sut: Mock, expected: Mock) {
            var sut = sut
            sut.clearAllModifiers()
            #expect(sut == expected)
        }
    }
}
