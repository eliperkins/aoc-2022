#if canImport(GameKit)
import AdventOfCodeKit
import GameKit

public struct Day12 {
    public static let sample = """
        Sabqponm
        abcryxxl
        accszExk
        acctuvwj
        abdefghi
        """

    public let input: String

    public init(
        input: String? = nil
    ) {
        if let input {
            self.input = input
        } else if let input = try? Input.day(12) {
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

    static func value(for character: Character) -> Int {
        if character == "S" {
            return Int.max - 1
        }
        if character == "E" {
            return value(for: "z")
        }
        guard let scalar = character.unicodeScalars.first else { fatalError() }
        return Self.valueLookupMap[scalar, default: Int.max - 1]
    }

    func makeGraph(from matrix: Matrix<Character>) -> GKGridGraph<GKGridGraphNode> {
        let graph = GKGridGraph(
            fromGridStartingAt: vector_int2(x: 0, y: 0),
            width: Int32(matrix.columns.count),
            height: Int32(matrix.rows.count),
            diagonalsAllowed: false
        )

        matrix.forEachPosition { letter, pos in
            guard let node = graph.node(atGridPosition: vector_int2(Int32(pos.x), Int32(pos.y))) else { return }
            let nodesToDetach = Point(x: pos.x, y: pos.y)
                .cardinalAdjacent
                .compactMap { (point: Point) -> (Point, Character)? in
                    if let adjacentNode = matrix.atPosition(x: point.x, y: point.y) {
                        return (point, adjacentNode)
                    }
                    return nil
                }
                .filter { _, adjacentNode in
                    Self.value(for: letter) + 1 < Self.value(for: adjacentNode)
                }
                .compactMap { point, _ in
                    graph.node(atGridPosition: vector_int2(Int32(point.x), Int32(point.y)))
                }
            node.removeConnections(to: nodesToDetach, bidirectional: false)
        }

        return graph
    }

    public func solvePart1() throws -> Int {
        let matrix = Matrix(input.lines.map(Array.init))
        guard let startingPosition = matrix.firstPosition(where: { $0 == "S" }),
            let endingPosition = matrix.firstPosition(where: { $0 == "E" })
        else { return 0 }

        let graph = makeGraph(from: matrix)

        guard
            let startingNode = graph.node(
                atGridPosition: vector_int2(Int32(startingPosition.x), Int32(startingPosition.y))),
            let endNode = graph.node(atGridPosition: vector_int2(Int32(endingPosition.x), Int32(endingPosition.y)))
        else { return 0 }

        let path = graph.findPath(from: startingNode, to: endNode)

        /// count steps, not nodes
        return path.dropFirst().count
    }

    public func solvePart2() throws -> Int {
        let matrix = Matrix(input.lines.map(Array.init))
        guard let endingPosition = matrix.firstPosition(where: { $0 == "E" }) else { return 0 }
        let startingPositions = matrix.collectLocations({ element, _ in element == "a" })

        let graph = makeGraph(from: matrix)

        return
            startingPositions
            .compactMap { (_, position) -> Int? in
                let path = graph.findPath(
                    from: graph.node(atGridPosition: vector_int2(Int32(position.x), Int32(position.y)))!,
                    to: graph.node(atGridPosition: vector_int2(Int32(endingPosition.x), Int32(endingPosition.y)))!
                )
                let steps = path.dropFirst().count
                if steps == 0 {
                    return nil
                }
                return steps
            }
            .min() ?? 0
    }
}
#endif
