//
//  SlotReelMatrixGenerator.swift
//  SlotReelKit
//
//  Utility for generating strict win-line result matrices.
//

import Foundation

/// Generates result matrices with exactly one winning line for classic slot layouts.
public enum SlotReelMatrixGenerator {
    /// Creates a random initial top-row offset for each column without forming a win line.
    public static func randomInitialTopOffsets(
        columnCount: Int,
        symbolCount: Int,
        visibleRowCount: Int
    ) -> [Int] {
        var topOffsets: [Int]
        repeat {
            topOffsets = (0..<columnCount).map { _ in Int.random(in: 0..<symbolCount) }
        } while !winLines(
            in: matrixFromTopOffsets(topOffsets, columnCount: columnCount, visibleRowCount: visibleRowCount, symbolCount: symbolCount),
            visibleRowCount: visibleRowCount,
            columnCount: columnCount
        ).isEmpty
        return topOffsets
    }

    /// Builds the visible matrix from top offsets using cyclic symbol indexing.
    public static func matrixFromTopOffsets(
        _ topOffsets: [Int],
        columnCount: Int,
        visibleRowCount: Int,
        symbolCount: Int
    ) -> [[Int]] {
        (0..<visibleRowCount).map { row in
            (0..<columnCount).map { column in
                (topOffsets[column] + row) % symbolCount
            }
        }
    }

    /// Generates a matrix with exactly one winning line containing `targetSymbolIndex`.
    public static func generateStrictMatrix(
        targetSymbolIndex: Int,
        columnCount: Int,
        visibleRowCount: Int,
        symbolCount: Int
    ) -> [[Int]] {
        let target = max(0, min(symbolCount - 1, targetSymbolIndex))
        var matrix = Array(
            repeating: Array(repeating: -1, count: columnCount),
            count: visibleRowCount
        )

        let winLine = Int.random(in: 0..<5)
        if winLine <= 2 {
            for column in 0..<columnCount {
                matrix[winLine][column] = target
            }
        } else if winLine == 3 {
            for row in 0..<visibleRowCount {
                matrix[row][row] = target
            }
        } else {
            for row in 0..<visibleRowCount {
                matrix[row][columnCount - 1 - row] = target
            }
        }

        for row in 0..<visibleRowCount {
            for column in 0..<columnCount where matrix[row][column] == -1 {
                var candidates = Array(0..<symbolCount)
                candidates.shuffle()
                var placed = false
                for symbol in candidates {
                    matrix[row][column] = symbol
                    let wins = winLines(in: matrix, visibleRowCount: visibleRowCount, columnCount: columnCount)
                    let illegal = wins.count > 1 || wins.contains { $0.value != target }
                    if illegal {
                        matrix[row][column] = -1
                    } else {
                        placed = true
                        break
                    }
                }
                if !placed {
                    matrix[row][column] = (target + 1) % symbolCount
                }
            }
        }

        let wins = winLines(in: matrix, visibleRowCount: visibleRowCount, columnCount: columnCount)
        if wins.count != 1 || wins.first?.value != target {
            return generateStrictMatrix(
                targetSymbolIndex: target,
                columnCount: columnCount,
                visibleRowCount: visibleRowCount,
                symbolCount: symbolCount
            )
        }
        return matrix
    }

    /// Returns detected win lines in a matrix.
    ///
    /// Line indices:
    /// - `0...visibleRowCount-1`: horizontal rows
    /// - `visibleRowCount`: main diagonal
    /// - `visibleRowCount + 1`: anti diagonal
    public static func winLines(
        in matrix: [[Int]],
        visibleRowCount: Int,
        columnCount: Int
    ) -> [(line: Int, value: Int)] {
        var wins: [(Int, Int)] = []

        for row in 0..<visibleRowCount {
            let value = matrix[row][0]
            if value != -1,
               columnCount >= 3,
               matrix[row][1] == value,
               matrix[row][2] == value {
                wins.append((row, value))
            }
        }

        let diagonalValue = matrix[0][0]
        if diagonalValue != -1,
           visibleRowCount >= 3,
           columnCount >= 3,
           matrix[1][1] == diagonalValue,
           matrix[2][2] == diagonalValue {
            wins.append((visibleRowCount, diagonalValue))
        }

        let antiDiagonalValue = matrix[0][columnCount - 1]
        if antiDiagonalValue != -1,
           visibleRowCount >= 3,
           columnCount >= 3,
           matrix[1][1] == antiDiagonalValue,
           matrix[2][0] == antiDiagonalValue {
            wins.append((visibleRowCount + 1, antiDiagonalValue))
        }

        return wins
    }
}
