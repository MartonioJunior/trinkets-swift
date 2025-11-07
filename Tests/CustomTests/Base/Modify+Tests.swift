//
//  Modify+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 05/11/2025.
//

@testable import Custom
import Testing

struct ModifyTests {
    @Test("Creates a new setter", arguments: [
        (5, true)
    ])
    func initializer(_ newValue: Int, output: Bool) {
        let sut = Modify {
            $0 = newValue
            return output
        }
        var test = 9
        let result = sut.setter(&test)
        #expect(test == newValue)
        #expect(result == output)
    }

    @Test("Creates a new setter based on another modifier", arguments: [
        (MockModifier(22), 22)
    ])
    func initializer(_ modifier: MockModifier<Int>, expected: Int) {
        let sut = Modify(modifier)
        var test = 99
        sut.setter(&test)
        #expect(test == expected)
    }

    @Test("Reworks a type's property into a new value", arguments: [
        (12.0, false)
    ])
    func customize(_ newValue: Double, output: Bool) {
        let sut = Modify.customize(\MockCharacter.spd) {
            $0 = newValue
            return output
        }
        var target = MockCharacter()
        let result = sut.apply(to: &target)
        let expected = MockCharacter(spd: newValue)
        #expect(target == expected)
        #expect(result == output)
    }

    @Test("Replaces a type's property with a new value", arguments: [
        (16.0, 12.0, 16.0)
    ])
    func replace(_ oldValue: Double, with newValue: Double, output: Double) {
        let sut = Modify.replace(\MockCharacter.spd, with: newValue)
        var target = MockCharacter(spd: oldValue)
        let result = sut.apply(to: &target)
        let expected = MockCharacter(spd: newValue)
        #expect(target == expected)
        #expect(result == output)
    }

    // MARK: Self: Modifier
    struct ConformsToModifier {
        @Test("Applies the setter into a target", arguments: [
            (MockModifier(22), 22)
        ])
        func initializer(_ modifier: MockModifier<Int>, expected: Int) {
            let sut = Modify(modifier)
            var test = 99
            sut.apply(to: &test)
            #expect(test == expected)
        }
    }

    // MARK: Self.Output == Void
    struct OutputIsVoid {
        @Test("Sets a property value to nil")
        func clear() {
            let sut = Modify.clear(\MockCharacter.spd)
            var target = MockCharacter()
            sut.apply(to: &target)
            let expected = MockCharacter(spd: nil)
            #expect(target == expected)
        }

        @Test("Defines a new value to a property")
        func set() {
            let sut = Modify.set(\MockCharacter.body, to: "h")
            var target = MockCharacter()
            sut.apply(to: &target)
            let expected = MockCharacter(body: "h")
            #expect(target == expected)
        }

        @Test("Alters the value of the property using the transformation")
        func transform() {
            let sut = Modify.transform(\MockCharacter.dexterity) { $0 * 2 }
            var target = MockCharacter(dexterity: 40)
            sut.apply(to: &target)
            let expected = MockCharacter(dexterity: 80)
            #expect(target == expected)
        }
    }
}
