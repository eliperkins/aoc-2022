import AdventOfCodeKit
import Collections
import Parsing

public struct Day15 {
    public static let sample = """
        Sensor at x=2, y=18: closest beacon is at x=-2, y=15
        Sensor at x=9, y=16: closest beacon is at x=10, y=16
        Sensor at x=13, y=2: closest beacon is at x=15, y=3
        Sensor at x=12, y=14: closest beacon is at x=10, y=16
        Sensor at x=10, y=20: closest beacon is at x=10, y=16
        Sensor at x=14, y=17: closest beacon is at x=10, y=16
        Sensor at x=8, y=7: closest beacon is at x=2, y=10
        Sensor at x=2, y=0: closest beacon is at x=2, y=10
        Sensor at x=0, y=11: closest beacon is at x=2, y=10
        Sensor at x=20, y=14: closest beacon is at x=25, y=17
        Sensor at x=17, y=20: closest beacon is at x=21, y=22
        Sensor at x=16, y=7: closest beacon is at x=15, y=3
        Sensor at x=14, y=3: closest beacon is at x=15, y=3
        Sensor at x=20, y=1: closest beacon is at x=15, y=3
        """

    public let input: String

    public init(
        input: String? = nil
    ) {
        if let input {
            self.input = input
        } else if let input = try? Input.day(15) {
            self.input = input
        } else {
            self.input = Self.sample
        }
    }

    struct Sensor {
        let location: Point
        let closestBeacon: Point
        let manhattanDistance: Int
        let minY: Int
        let maxY: Int
        let minX: Int
        let maxX: Int

        init(
            location: Point, closestBeacon: Point
        ) {
            self.location = location
            self.closestBeacon = closestBeacon
            self.manhattanDistance = location.manhattanDistance(to: closestBeacon)
            self.minY = location.y - manhattanDistance
            self.maxY = location.y + manhattanDistance
            self.minX = location.x - manhattanDistance
            self.maxX = location.x + manhattanDistance
        }

        func sensorCoverage(for row: Int) -> ClosedRange<Int>? {
            guard (minY...maxY).contains(row) else { return nil }
            let diff = abs(row - location.y)
            let iterations = manhattanDistance - diff
            return (location.x - iterations)...(location.x + iterations)
        }
    }

    func findCoveredRanges(in row: Int, sensors: [Sensor]) -> [ClosedRange<Int>] {
        sensors
            .compactMap { $0.sensorCoverage(for: row) }
            .sorted { lhs, rhs in lhs.lowerBound < rhs.lowerBound }
            .reduce(into: []) { acc, next in
                if acc.isEmpty {
                    acc.append(next)
                }

                // collapse ranges if they contain or overlap another
                if let last = acc.last {
                    if last.fullyContains(next) {
                        // no-op
                    } else if next.fullyContains(last) {
                        acc.removeLast()
                        acc.append(next)
                    } else if next.overlaps(last) {
                        acc.removeLast()
                        acc.append(last.merging(with: next))
                    } else {
                        acc.append(next)
                    }
                } else {
                    acc.append(next)
                }
            }
    }

    struct PointParser: Parser {
        func parse(_ input: inout Substring) throws -> Point {
            try Parse(Point.init(x:y:)) {
                "x="
                Int.parser()
                ", y="
                Int.parser()
            }.parse(&input)
        }
    }

    struct SensorParser: Parser {
        func parse(_ input: inout Substring) throws -> [Sensor] {
            try Many {
                Parse(Sensor.init) {
                    "Sensor at "
                    PointParser()
                    ": closest beacon is at "
                    PointParser()
                }
            } separator: {
                "\n"
            }.parse(&input)
        }
    }

    public func solvePart1(row: Int) throws -> Int {
        let sensors = try SensorParser().parse(input)
        let coveredRanges = findCoveredRanges(in: row, sensors: sensors)

        let knownObjects = sensors.map(\.location) + sensors.map(\.closestBeacon)
        let objectLocations = Set(
            knownObjects
                .filter({ $0.y == row })
                .map(\.x)
        )

        return coveredRanges.reduce(0) { acc, next in acc + next.count }
            - objectLocations.count
    }

    public func solvePart2(searchSpace: Int) throws -> Int {
        let sensors = try SensorParser().parse(input)
        for y in 0...searchSpace {
            let coveredRanges = findCoveredRanges(in: y, sensors: sensors)
            // more than one range means we have a gap where a beacon could be
            if coveredRanges.count > 1 {
                guard let first = coveredRanges.first else { continue }
                // assumes gaps is always size 1, immediately after first range
                let x = first.upperBound + 1
                return x * 4_000_000 + y
            }
        }
        return 0
    }
}
