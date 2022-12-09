import AdventOfCodeKit
import Algorithms
import Parsing

public struct Day9 {
    public static let sample = """
        R 4
        U 4
        L 3
        D 1
        R 4
        D 1
        L 5
        R 2
        """

    public static let samplePart2 = """
        R 5
        U 8
        L 8
        D 3
        R 17
        D 10
        L 25
        U 20
        """

    public let input: String

    public init(
        input: String? = nil
    ) {
        if let input {
            self.input = input
        } else if let input = try? Input.day(9) {
            self.input = input
        } else {
            self.input = Self.sample
        }
    }

    struct Motion {
        enum Direction: String {
            case up = "U"
            case down = "D"
            case left = "L"
            case right = "R"
        }

        let direction: Direction
        let steps: Int
    }

    let parser = Many {
        Parse(Motion.init) {
            Prefix(1).map(String.init).compactMap(Motion.Direction.init)
            Whitespace(1)
            Int.parser()
        }
    } separator: {
        "\n"
    }

    func move(head: Point, in direction: Motion.Direction) -> Point {
        var head = head
        switch direction {
        case .up:
            head.y += 1
        case .right:
            head.x += 1
        case .left:
            head.x -= 1
        case .down:
            head.y -= 1
        }
        return head
    }

    func update(head: Point, tail: Point) -> Point {
        var tail = tail
        if !head.adjecent.union([head]).contains(tail) {
            let xDiff = head.x - tail.x
            let yDiff = head.y - tail.y
            if xDiff != 0 {
                if xDiff > 0 {
                    tail.x += 1
                } else {
                    tail.x -= 1
                }
            }
            if yDiff != 0 {
                if yDiff > 0 {
                    tail.y += 1
                } else {
                    tail.y -= 1
                }
            }
        }
        return tail
    }

    public func solvePart1() throws -> Int {
        let motions = try parser.parse(input)

        var head = Point(x: 0, y: 0)
        var tail = Point(x: 0, y: 0)
        var visited = Set<Point>([tail])

        for motion in motions {
            for _ in (1...motion.steps) {
                head = move(head: head, in: motion.direction)
                tail = update(head: head, tail: tail)
                visited.insert(tail)
            }
        }

        return visited.count
    }

    public func solvePart2() throws -> Int {
        let motions = try parser.parse(input)

        let keys = ["H", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        var points = Dictionary(uniqueKeysWithValues: zip(keys, Array(repeating: Point(x: 0, y: 0), count: keys.count)))
        var visited = Set<Point>([Point(x: 0, y: 0)])

        for motion in motions {
            for _ in (1...motion.steps) {
                let head = points["H", default: Point(x: 0, y: 0)]
                points["H"] = move(head: head, in: motion.direction)

                keys.windows(ofCount: 2).forEach {
                    guard let headKey = $0.first, let tailKey = $0.last,
                        let head = points[headKey], let tail = points[tailKey]
                    else { return }
                    points[tailKey] = update(head: head, tail: tail)
                }

                if let tailKey = keys.last, let tail = points[tailKey] {
                    visited.insert(tail)
                }
            }
        }

        return visited.count
    }
}
