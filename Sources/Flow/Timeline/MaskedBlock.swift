//
//  MaskedBlock.swift
//  Trinkets
//
//  Created by Martônio Júnior on 02/09/2026.
//

/// Block that can derive new blocks through the use of masks.
public struct MaskedBlock<Key: Hashable, Chunk: Block> {
    // MARK: Variables
    /// List of masks registered in this track, which work as jump-off points to compose a track or obtain info about it's state.
    /// 
    /// The goal with this is to provide contextual information about the contents of a track through it's selection.
    var masks: [Key: Chunk.Mask]
    /// Block used as the reference.
    var block: Chunk
    // MARK: Initializers
    /// Creates a new masked block.
    /// - Parameters:
    ///   - block: Block to be masked.
    ///   - masks: Set of masks associated with the block.
    public init(_ block: Chunk, masks: [Key: Chunk.Mask] = [:]) {
        self.block = block
        self.masks = masks
    }
    // MARK: Methods
    /// Creates a chunk from a block.
    /// - Parameter key: Key representing the mask that represents the chunk.
    /// - Returns: New block with a new mask using the same element function.
    public func chunk(forKey key: Key) -> AnyBlockOf<Chunk>? {
        guard let mask = mask(forKey: key) else { return nil }

        return AnyBlock(mask: mask) { block.element(on: $0) }
    }
    /// Obtains a reference selection from a given mask registered in the track.
    /// - Parameter key: Key representing the mask.
    /// - Returns: Range associated with the mask, `nil` when no mask is registered with the given key.
    public func mask(forKey key: Key) -> Chunk.Mask? {
        masks[key]
    }
    /// Masks part of a block.
    /// - Parameters:
    ///   - mask: Selection defined on the track.
    ///   - key: Key used to represent the mask.
    ///
    public mutating func register(_ mask: Chunk.Mask, forKey key: Key) {
        masks[key] = mask
    }
    /// Removes the mask.
    /// - Parameter mask: Key representing the mask to be removed.
    public mutating func removeKey(_ key: Key) {
        masks.removeValue(forKey: key)
    }
}

// MARK: Self: Block
extension MaskedBlock: Block {
    // swiftlint:disable:next missing_docs
    public var mask: Chunk.Mask { block.mask }
    // swiftlint:disable:next missing_docs
    public func element(on instant: Chunk.Instant) -> Chunk.Element {
        block.element(on: instant)
    }
}
