//
//  MockCharacter.swift
//  Trinkets
//
//  Created by Martônio Júnior on 05/11/2025.
//

import Custom

public struct MockCharacter {
    @Slot var head = "a"
    @AttributeOf var body: String = "b"
    @StatOf var pants: String = "c"
    @AttributeSlot var shoes = "d"

    public private(set) var hp: Int = 50
    @Stat<MockModifier> var attack: Int = 28
    var spd: Double? = 250
    var dexterity: Double = 120
}

// MARK: Self: Equatable
extension MockCharacter: Equatable {
    public static func == (lhs: MockCharacter, rhs: MockCharacter) -> Bool {
        lhs.head == rhs.head
        && lhs.body == rhs.body
        && lhs.pants == rhs.pants
        && lhs.shoes == rhs.shoes
        && lhs.hp == rhs.hp
        && lhs.attack == rhs.attack
        && lhs.spd == rhs.spd
    }
}
