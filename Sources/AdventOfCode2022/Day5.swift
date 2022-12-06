import AdventOfCodeKit
import Foundation

#if canImport(RegexBuilder)
    import RegexBuilder
#endif

public struct Day5 {
    public static let sample = """
            [D]
        [N] [C]
        [Z] [M] [P]
         1   2   3

        move 1 from 2 to 1
        move 3 from 1 to 3
        move 2 from 2 to 1
        move 1 from 1 to 2
        """

    public let input: String

    public init(
        input: String? = nil
    ) {
        if let input {
            self.input = input
        } else if let input = try? Input.day(5) {
            self.input = input
        } else {
            self.input = Self.sample
        }
    }

    final class Ship {
        struct Move {
            let count: Int
            let source: Int
            let destination: Int

            @available(macOS 13.0, *)
            static let moveRegex = Regex {
                "move "
                Capture {
                    OneOrMore(.digit)
                }
                " from "
                Capture {
                    OneOrMore(.digit)
                }
                " to "
                Capture {
                    OneOrMore(.digit)
                }
            }

            init(
                count: Int, source: Int, destination: Int
            ) {
                self.count = count
                self.source = source
                self.destination = destination
            }

            init?(
                _ line: String
            ) throws {
                if #available(macOS 13.0, *) {
                    guard let match = try Self.moveRegex.firstMatch(in: line),
                        let count = Int(match.1),
                        let source = Int(match.2),
                        let destination = Int(match.3)
                    else { return nil }
                    self.init(count: count, source: source, destination: destination)
                } else {
                    let parts = line.split(separator: " ")
                        .compactMap { Int(String($0)) }
                    if parts.count != 3 {
                        return nil
                    }
                    self.init(count: parts[0], source: parts[1], destination: parts[2])
                }
            }
        }

        private var storage = [Int: [String]]()
        private let size: Int

        init(
            size: Int, boxes: [[String?]]
        ) {
            self.size = size
            for index in (0..<size) {
                for boxLine in boxes {
                    if boxLine.indices.contains(index), let box = boxLine[index] {
                        var column = storage[index + 1, default: []]
                        column.insert(box, at: 0)
                        storage[index + 1] = column
                    }
                }
            }
        }

        func execute(_ move: Move) {
            var source = storage[move.source, default: []]
            var destination = storage[move.destination, default: []]
            for _ in 1...move.count {
                if let box = source.popLast() {
                    destination.append(box)
                }
            }
            storage[move.source] = source
            storage[move.destination] = destination
        }

        func executePartTwo(_ move: Move) {
            var source = storage[move.source, default: []]
            var destination = storage[move.destination, default: []]

            let toMove = source.suffix(move.count)
            source = source.dropLast(move.count)
            destination.append(contentsOf: toMove)

            storage[move.source] = source
            storage[move.destination] = destination
        }

        var message: String {
            (1...size).compactMap { storage[$0]?.last }.joined()
        }
    }

    func parseShipAndMoves() throws -> (Ship, [Ship.Move]) {
        let xs = input.lines.split(whereSeparator: { $0.isEmpty })
        guard let state = xs.first,
            let widthLine = state.last,
            let width = widthLine.split(separator: " ").compactMap({ Int(String($0)) }).max(),
            let moveStrings = xs.last
        else { fatalError() }
        let keyValues = widthLine.enumerated().compactMap({ (index, value) -> (Int, Int)? in
            guard let column = Int(String(value)) else { return nil }
            return (index, column)
        })
        let indexLookup = [Int: Int](uniqueKeysWithValues: keyValues)

        let boxes = state.dropLast().map {
            var array = [String?](repeating: nil, count: width)
            $0.unicodeScalars.enumerated()
                .filter { (_, char: UnicodeScalar) in CharacterSet.alphanumerics.contains(char) }
                .forEach { (index, char) in
                    if let column = indexLookup[index] {
                        // storage values are zero-indexed, but input values are 1-indexed
                        array[column - 1] = String(char)
                    }
                }
            return array
        }

        let moves = try moveStrings.compactMap(Ship.Move.init)

        return (Ship(size: width, boxes: boxes), moves)
    }

    public func solvePart1() throws -> String {
        let (ship, moves) = try parseShipAndMoves()
        for move in moves {
            ship.execute(move)
        }
        return ship.message
    }

    public func solvePart2() throws -> String {
        let (ship, moves) = try parseShipAndMoves()
        for move in moves {
            ship.executePartTwo(move)
        }
        return ship.message
    }
}
