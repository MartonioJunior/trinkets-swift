//
//  Modifiable+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 05/11/2025.
//

@testable import Custom
import Testing

struct ModifiableTests {
    struct Mock: Modifiable, Equatable {
        typealias Mod = MockModifier<Int>

        var numberOfMods: Int

        public init(_ numberOfMods: Int = 0) {
            self.numberOfMods = numberOfMods
        }
        
        mutating func apply(_ modifier: MockModifier<Int>) {
            numberOfMods += 1
        }

        mutating func clearModifiers(where predicate: (MockModifier<Int>) -> Bool) {
            for i in 0..<numberOfMods {
                let mod = Mod(i)
                if predicate(mod) { numberOfMods -= 1 }
            }
        }
    }

    @Test("Uses clearModifiers(where:) with an always true predicate", arguments: [
        (Mock(9), Mock(0))
    ])
    func clearAllModifiers(_ sut: Mock, expected: Mock) {
        var sut = sut
        sut.clearAllModifiers()
        #expect(sut == expected)
    }
}

// MARK: ConcreteModifier (EX)
extension ModifyTests {
    @Test("Composes a modifier that is applied to a modifiable target")
    func applicable() {
        var sut = MockCharacter()
        let base = MockModifier(23)
        let modifier = base.applicable(on: \MockCharacter.$attack)
        modifier.apply(to: &sut)
        #expect(sut.$attack.modifiers == [base])
    }
}
