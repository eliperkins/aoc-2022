import AdventOfCodeKit
import Parsing

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

    let parser = Many {
        Many {
            Int.parser()
        } separator: {
            "\n"
        }
    } separator: {
        "\n"
    }

    public func solvePart1() throws -> Int {
        try parser.parse(input)
            .map { $0.sum() }
            .max() ?? 0
    }

    public func solvePart2() throws -> Int {
        try parser.parse(input)
            .map { $0.sum() }
            .max(count: 3)
            .sum()
    }
}
