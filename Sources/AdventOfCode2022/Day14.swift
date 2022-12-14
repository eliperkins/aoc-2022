import AdventOfCodeKit
import Algorithms
import Parsing

public struct Day14 {
    public static let sample = """
        498,4 -> 498,6 -> 496,6
        503,4 -> 502,4 -> 502,9 -> 494,9
        """

    public let input: String

    public init(
        input: String? = nil
    ) {
        if let input {
            self.input = input
        } else if let input = try? Input.day(14) {
            self.input = input
        } else {
            self.input = Self.sample
        }
    }

    let parser = Many {
        Many {
            Parse(Point.init(x:y:)) {
                Int.parser()
                ","
                Int.parser()
            }
        } separator: {
            " -> "
        }
    } separator: {
        "\n"
    }

    final class Cave {
        private var matrix: Matrix<String>
        let maxX: Int
        let maxY: Int

        init(
            rocks: [[Point]]
        ) {
            let maxX = rocks.flatMap { $0.map(\.x) }.max() ?? 500
            let maxY = rocks.flatMap { $0.map(\.y) }.max() ?? 500
            self.maxX = maxX
            self.maxY = maxY
            self.matrix = Matrix(repeating: ".", width: maxX * 2, height: maxY + 2)
            for rock in rocks {
                for xs in rock.windows(ofCount: 2) {
                    guard let start = xs.first, let end = xs.last else {
                        continue
                    }
                    if start.x == end.x {
                        for y in min(start.y, end.y)...max(start.y, end.y) {
                            matrix.set(value: "#", x: start.x, y: y)
                        }
                    } else if start.y == end.y {
                        for x in min(start.x, end.x)...max(start.x, end.x) {
                            matrix.set(value: "#", x: x, y: start.y)
                        }
                    } else {
                        fatalError("can't create straight line")
                    }
                }
            }
        }

        func isInAbyss(_ point: Point) -> Bool {
            matrix.atPosition(x: point.x, y: point.y) == nil
        }

        func isPositionStatic(_ point: Point) -> Bool {
            if let atPosition = matrix.atPosition(x: point.x, y: point.y) {
                return atPosition != "."
            }
            return true
        }

        let sandPoint = Point(x: 500, y: 0)

        // keep track of last path to optimize next sand drop
        private lazy var lastPath = [sandPoint]

        func nextSand() -> Point {
            func fall(from origin: Point) -> Point {
                let below = Point(x: origin.x, y: origin.y + 1)
                let leftDiagonal = Point(x: origin.x - 1, y: origin.y + 1)
                let rightDiagonal = Point(x: origin.x + 1, y: origin.y + 1)
                if let nextPosition = [below, leftDiagonal, rightDiagonal].first(where: { !isPositionStatic($0) }) {
                    lastPath.append(nextPosition)
                    return fall(from: nextPosition)
                }

                lastPath.removeLast()
                return origin
            }

            return fall(from: lastPath.last ?? sandPoint)
        }

        enum DropResult {
            case inAbyss
            case dropped(Point)
        }

        func dropSand(where fn: (Point) -> Bool) -> DropResult {
            let sand = nextSand()
            if fn(sand) {
                return .inAbyss
            }
            matrix.set(value: "o", x: sand.x, y: sand.y)
            return .dropped(sand)
        }
    }

    public func solvePart1() throws -> Int {
        let rockPoints = try parser.parse(input)
        let cave = Cave(rocks: rockPoints)

        var count = 0
        while true {
            let result = cave.dropSand(where: { $0.x > cave.maxX || $0.y > cave.maxY })
            switch result {
            case .inAbyss:
                return count
            case .dropped:
                count += 1
            }
        }

        return count
    }

    public func solvePart2() throws -> Int {
        let rockPoints = try parser.parse(input)
        let cave = Cave(rocks: rockPoints)

        var lastSand: Point?
        var count = 0
        while lastSand != Point(x: 500, y: 0) {
            let result = cave.dropSand(where: { cave.isInAbyss($0) })
            switch result {
            case .inAbyss:
                return count
            case .dropped(let nextSand):
                lastSand = nextSand
                count += 1
            }
        }

        return count
    }
}
