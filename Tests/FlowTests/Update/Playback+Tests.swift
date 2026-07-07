//
//  Playback+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 28/07/2026.
//

@testable import Flow
import Testing

struct PlaybackTests {
    @Test("Creates a new Playback", arguments: [
        (Playback.Loop.endless, Playback.Wrap.freeze),
        (Playback.Loop.fixed(5), Playback.Wrap.hold),
        (Playback.Loop.oneShot, Playback.Wrap.reset),
        (Playback.Loop.fixed(3), Playback.Wrap?.none)
    ])
    func initializer(_ loop: Playback.Loop, wrap: Playback.Wrap?) {
        let result = Playback(loop, wrap: wrap)
        #expect(result.loop == loop)
        #expect(result.wrap == wrap)
    }

    @Test("Advances playback to next cycle", arguments: [
        (Playback(.endless, wrap: .freeze), (true, Playback(.endless, wrap: .freeze))),
        (Playback(.fixed(5), wrap: .freeze), (true, Playback(.fixed(4), wrap: .freeze))),
        (Playback(.oneShot, wrap: .freeze), (false, Playback(.fixed(0), wrap: .freeze)))
    ])
    func advance(_ sut: Playback, expected: (result: Bool, state: Playback)) async throws {
        var sut = sut
        let result = sut.advance()
        #expect(result == expected.result)
        #expect(sut == expected.state)
    }

    // MARK: Self.Loop
    struct LoopTests {
        @Test("Constants for Loop", arguments: [
            (Playback.Loop.oneShot, Playback.Loop.fixed(0))
        ])
        func constants(_ sut: Playback.Loop, expected: Playback.Loop) {
            #expect(sut == expected)
        }
    }
}
