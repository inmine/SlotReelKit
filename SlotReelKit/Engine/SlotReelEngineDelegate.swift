//
//  SlotReelEngineDelegate.swift
//  SlotReelKit
//
//  Optional delegate callbacks for spin lifecycle events.
//

import Foundation

/// Receives lifecycle callbacks from ``SlotReelEngine``.
public protocol SlotReelEngineDelegate: AnyObject {
    /// Called when a spin session starts.
    func slotReelEngine(_ engine: SlotReelEngine, didStartSpin session: SlotReelSpinSession)

    /// Called when an individual column finishes scrolling.
    func slotReelEngine(_ engine: SlotReelEngine, didStopColumn column: Int, in session: SlotReelSpinSession)

    /// Called when all columns have stopped.
    func slotReelEngine(_ engine: SlotReelEngine, didFinishSpin session: SlotReelSpinSession)
}

/// Default no-op implementations.
public extension SlotReelEngineDelegate {
    func slotReelEngine(_ engine: SlotReelEngine, didStartSpin session: SlotReelSpinSession) {}
    func slotReelEngine(_ engine: SlotReelEngine, didStopColumn column: Int, in session: SlotReelSpinSession) {}
    func slotReelEngine(_ engine: SlotReelEngine, didFinishSpin session: SlotReelSpinSession) {}
}
