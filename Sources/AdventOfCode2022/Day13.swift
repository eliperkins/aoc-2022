import Foundation
import Parsing

public struct Day13 {
    public static let sample = """
        [1,1,3,1,1]
        [1,1,5,1,1]

        [[1],[2,3,4]]
        [[1],4]

        [9]
        [[8,7,6]]

        [[4,4],4,4]
        [[4,4],4,4,4]

        [7,7,7,7]
        [7,7,7]

        []
        [3]

        [[[]]]
        [[]]

        [1,[2,[3,[4,[5,6,7]]]],8,9]
        [1,[2,[3,[4,[5,6,0]]]],8,9]
        """

    public let input: String

    public init(
        input: String? = nil
    ) {
        if let input {
            self.input = input
        } else if let input = try? Input.day(13) {
            self.input = input
        } else {
            self.input = Self.sample
        }
    }

    indirect enum Element: Comparable {
        case value(Int)
        case element([Element])

        static func < (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case (.value(let lhs), .value(let rhs)):
                return lhs < rhs
            case (.element(let lhs), .element(let rhs)):
                return lhs.lexicographicallyPrecedes(rhs)
            case (.value, let rhsElement):
                return .element([lhs]) < rhsElement
            case (let lhsElement, .value):
                return lhsElement < .element([rhs])
            }
        }
    }

    struct ElementParser: Parser {
        func parse(_ input: inout Substring) throws -> [Element] {
            try Parse {
                "["
                Many {
                    OneOf {
                        Int.parser().map { Element.value($0) }
                        ElementParser().map { Element.element($0) }
                    }
                } separator: {
                    ","
                } terminator: {
                    "]"
                }
            }
            .parse(&input)
        }
    }

    struct ElementPairParser: Parser {
        func parse(_ input: inout Substring) throws -> [(Element, Element)] {
            try Many {
                Many(2) {
                    ElementParser()
                } separator: {
                    "\n"
                }
                .compactMap { items -> (Element, Element)? in
                    guard let first = items.first, let second = items.last else {
                        return nil
                    }

                    return (.element(first), .element(second))
                }
            } separator: {
                "\n\n"
            }
            .parse(&input)
        }
    }

    public func solvePart1() throws -> Int {
        try ElementPairParser()
            .parse(input)
            .enumerated()
            .reduce(0) { (acc, next) in
                let (index, pair) = next
                if pair.0 < pair.1 {
                    return acc + (index + 1)
                }
                return acc
            }
    }

    public func solvePart2() throws -> Int {
        let dividerPackets = [
            Element.element([.element([.value(2)])]),
            Element.element([.element([.value(6)])]),
        ]
        let allPackets =
            try ElementPairParser()
            .parse(input)
            .flatMap { [$0.0, $0.1] }
            + dividerPackets
        let packets = allPackets.sorted()
        return
            dividerPackets
            .compactMap { packets.firstIndex(of: $0) }
            .map { $0 + 1 }
            .product()
    }
}
