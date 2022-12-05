import AdventOfCodeKit
import Algorithms
import Foundation

public struct Day3 {
    public static let sample = """
        vJrwpWtwJgWrhcsFMMfFFhFp
        jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
        PmmdzqPrVvPwwTWBwg
        wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
        ttgJtRGJQctTZtZT
        CrZsJsPPZsGzwwsLwLmpwMDw
        """

    public let input: String

    public init(
        input: String? = nil
    ) {
        if let input {
            self.input = input
        } else if let input = try? Input.day(3) {
            self.input = input
        } else {
            self.input = Self.sample
        }
    }

    static let valueLookupMap: [UnicodeScalar: Int] = {
        var dict = [UnicodeScalar: Int]()
        for (index, charValue) in (UnicodeScalar("a").value...UnicodeScalar("z").value).enumerated() {
            dict[UnicodeScalar(charValue)!] = index + 1
        }
        for (index, charValue) in (UnicodeScalar("A").value...UnicodeScalar("Z").value).enumerated() {
            dict[UnicodeScalar(charValue)!] = index + 27
        }
        return dict
    }()

    static func calculateScore(for set: Set<Character>) -> Int {
        set.flatMap(\.unicodeScalars).reduce(0) { partialResult, char in
            partialResult + Self.valueLookupMap[char, default: 0]
        }
    }

    static func calculateScore(for sets: [Set<Character>]) -> Int {
        sets.reduce(0) { acc, next in
            acc + Self.calculateScore(for: next)
        }
    }

    public func solvePart1() throws -> Int {
        let common: [Set<Character>] = input
            .lines
            .map { line in
                let xs = Array(line.chunks(ofCount: line.count / 2))
                guard let first = xs.first, let last = xs.last else { return [] }
                return Set(first).intersection(Set(last))
            }
        return Self.calculateScore(for: common)
    }

    public func solvePart2() throws -> Int {
        let common: [Set<Character>] = input
            .lines
            .chunks(ofCount: 3)
            .map { next in
                let xs = next.map(Set.init)
                guard let first = xs.first else { return [] }
                let rest = xs.dropFirst()
                return rest.reduce(first) { partialResult, nextSet in
                    partialResult.intersection(nextSet)
                }
            }
        return Self.calculateScore(for: common)
    }
}
