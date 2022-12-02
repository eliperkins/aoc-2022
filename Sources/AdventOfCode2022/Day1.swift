import AdventOfCodeKit
import Algorithms

public struct Day1 {
    public static let sample = """
        1000
        2000
        3000

        4000

        5000
        6000

        7000
        8000
        9000

        10000
        """

    public let input: String

    public init(
        input: String? = nil
    ) {
        if let input {
            self.input = input
        } else if let input = try? Input.day(1) {
            self.input = input
        } else {
            self.input = Self.sample
        }
    }

    public func solvePart1() throws -> Int {
        input.paragraphs
            .map { $0.compactMap(Int.init).reduce(0, +) }
            .max() ?? 0
    }

    public func solvePart2() throws -> Int {
        input.paragraphs
            .map { $0.compactMap(Int.init).reduce(0, +) }
            .max(count: 3)
            .reduce(0, +)
    }
}
