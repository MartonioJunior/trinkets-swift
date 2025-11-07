//
//  Customizable+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 05/11/2025.
//

@testable import Custom
import Testing

struct CustomizableTests {
    typealias Mock = ModifierGroup<Mod>
    typealias Mod = MockModifier<Int>

    @Test("Applies all modifiers to the current target type", arguments: [
        (ModifierGroup([Mod(89), Mod(45)]), 12, 45)
    ])
    func apply(_ sut: Mock, to target: Int, expected: Int) {
        var target = target
        sut.apply(to: &target)
        #expect(target == expected)
    }

    // MARK: Self: Modifiable
    struct ConformsToModifiable {
        @Test("Combines modifiers into target, removing modifiers", arguments: [
            (ModifierGroup([Mod(89), Mod(45)]), 12, 45)
        ])
        func merge(_ sut: Mock, into target: Int, expected: Int) {
            var sut = sut
            var target = target
            sut.merge(into: &target)
            #expect(target == expected)
            #expect(sut.modifiers.isEmpty)
        }

        @Test("Applies modifiers into part of itself", .disabled("Method has implementation inconsistencies"), arguments: [
            (Stat<Mod>(wrappedValue: 22, modifiers: [Mod(89), Mod(45)]), Stat<Mod>(wrappedValue: 22, modifiers: [Mod(89), Mod(45), Mod(13)]))
        ])
        func merge(_ sut: Stat<Mod>, expected: Stat<Mod>) {
            var sut = sut
            sut.merge(on: \.base)
            #expect(sut == expected)
        }

        struct SelfMergeable: Modifiable, Customizable, Equatable {
            var value: Int
            var modifiers: [Modify<Self, Void>]

            init(_ value: Int, mods: [Modify<Self, Void>]) {
                self.value = value
                self.modifiers = mods
            }

            mutating func apply(_ modifier: Modify<Self, Void>) {
                modifiers.append(modifier)
            }

            mutating func clearModifiers(where predicate: (Modify<Self, Void>) -> Bool) {
                modifiers.removeAll(where: predicate)
            }

            static func == (lhs: Self, rhs: Self) -> Bool {
                lhs.value == rhs.value
            }
        }

        @Test("Merges on the instance itself")
        func mergeSelf() {
            var sut = SelfMergeable(4, mods: [
                Modify { $0.value = 8 },
                Modify { $0.value = 15 }
            ])
            let expected = SelfMergeable(15, mods: [])
            sut.merge()
            #expect(sut == expected)
        }
    }
}
