//
//  AnyBlock.swift
//  Trinkets
//
//  Created by Martônio Júnior on 30/08/2026.
//

import MatheRange
/// Short-hand alias for a type-erased block.
public typealias AnyBlockOf<B: Block> = AnyBlock<B.Mask, B.Instant, B.Element>
/// Type-erased implementation of the block using a closure.
public struct AnyBlock<Mask: Boundary, Instant, Element> {
    // swiftlint:disable:next missing_docs
    public var mask: Mask
    /// Closure that retrieves the element for a given instant.
    nonisolated var f: (Instant) -> Element
    // MARK: Initializers
    /// Creates a new block.
    /// - Parameters:
    ///   - mask: Boundary occupied by the block.
    ///   - f: Closure that retrieves the element for a given instant.
    public init(mask: Mask, f: @escaping (Instant) -> Element) {
        self.mask = mask
        self.f = f
    }
    /// Creates a new block by type-erasure.
    /// - Parameter block: Block to be type-erased.
    public init<B: Block>(_ block: B) where B.Mask == Mask, B.Element == Element, B.Instant == Instant {
        self.mask = block.mask
        self.f = block.element
    }
}

// MARK: DotSyntax
public extension AnyBlock {
    /// Creates a new interval block with a fixed value.
    /// - Parameters:
    ///   - mask: Boundary occupied by the block.
    ///   - value: Function describing the value for the entire spread.
    static func always(_ mask: Mask, value: @autoclosure @escaping () -> Element) -> Self {
        .init(mask: mask) { _ in value() }
    }
}

// MARK: Self: Block
extension AnyBlock: Block {
    // swiftlint:disable:next missing_docs
    public func element(on instant: Instant) -> Element {
        f(instant)
    }
}

// MARK: Self: Selectable
extension AnyBlock: Selectable where Mask: Selectable {
    // swiftlint:disable:next missing_docs
    public func canBeSelected(by selection: Mask.Selection) -> Bool {
        mask.canBeSelected(by: selection)
    }
}

// MARK: Self: Sendable
extension AnyBlock: Sendable where Mask: Sendable, Instant: Sendable, Element: Sendable {}

// MARK: Self.Mask: BoundaryOfOne
public extension AnyBlock {
    /// Creates a new instant block with a value function.
    /// 
    /// An instant block starts and ends at the same specified value.
    /// - Parameters:
    ///   - instant: Reference Instant.
    ///   - f: Function describing the value for the entire spread.
    static func instant(
        _ instant: Instant,
        f: @escaping (Instant) -> Element
    ) -> Self where Mask == BoundaryOfOne<Instant> {
        .init(mask: BoundaryOfOne(instant), f: f)
    }
    /// Creates a new instant with a fixed value.
    /// 
    /// A instant block starts and ends at the same specified value.
    /// - Parameters:
    ///   - instant: Reference Instant.
    ///   - value: Function describing the value for the entire spread.
    static func point(
        _ instant: Instant,
        value: @autoclosure @escaping () -> Element
    ) -> Self where Mask == BoundaryOfOne<Instant> {
        .instant(instant) { _ in value() }
    }
}

// MARK: Self.Mask: ClosedRange
public extension AnyBlock {
    /// Defines a block from a stamp mask.
    /// - Parameters:
    ///   - stamp: Stamp representing the boundary mask.
    ///   - f: Function describing the value for the entire spread.
    static func stamp(
        _ stamp: StampOf<Instant>,
        f: @escaping (Instant) -> Element
    ) -> Self where Mask == ClosedRange<Instant> {
        .init(mask: stamp.range, f: f)
    }
}

// MARK: Block (EX)
public extension Block {
    /// Maps a block's element as a new block.
    /// - Parameter transform: Transformation for the element.
    /// - Returns: New block that returns the transformed value.
    func mapElement<T>(_ transform: @escaping (Element) -> T) -> AnyBlock<Self.Mask, Self.Instant, T> {
        .init(mask: mask) { transform(element(on: $0)) }
    }
}
