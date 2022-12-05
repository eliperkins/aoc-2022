import AdventOfCodeKit
import Parsing

public struct Day4 {
    public static let sample = """
        2-4,6-8
        2-3,4-5
        5-7,7-9
        2-8,3-7
        6-6,4-6
        2-6,4-8
        """

    public let input: String

    public init(
        input: String? = nil
    ) {
        if let input {
            self.input = input
        } else if let input = try? Input.day(4) {
            self.input = input
        } else {
            self.input = Self.sample
        }
    }

    let parser = Many {
        Many(2) {
            Int.parser()
            "-"
            Int.parser()
        } separator: {
            ","
        }.map {
            $0.map { first, last in
                first...last
            }
        }
    } separator: {
        "\n"
    }

    public func solvePart1() throws -> Int {
        let xs = try parser.parse(input)
        return xs.reduce(0) { acc, next in
            guard let first = next.first, let second = next.last else {
                return acc
            }
            if first.fullyContains(second) || second.fullyContains(first) {
                return acc + 1
            }
            return acc
        }
    }

    public func solvePart2() throws -> Int {
        let xs = try parser.parse(input)
        return xs.reduce(0) { acc, next in
            guard let first = next.first, let second = next.last else {
                return acc
            }
            if first.overlaps(second) {
                return acc + 1
            }
            return acc
        }
    }
}

extension ClosedRange where Bound: SignedInteger, Bound.Stride: SignedInteger {
    func fullyContains(_ range: ClosedRange<Bound>) -> Bool {
        self.lowerBound <= range.lowerBound && self.upperBound >= range.upperBound
    }

    func overlaps(_ range: ClosedRange<Bound>) -> Bool {
        contains(range.upperBound)
            || contains(range.lowerBound)
            || range.contains(self.upperBound)
            || range.contains(self.lowerBound)
    }
}
