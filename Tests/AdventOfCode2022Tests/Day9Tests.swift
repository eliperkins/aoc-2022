import AdventOfCode2022
import XCTest

final class Day9Tests: XCTestCase {
    func test_part1_test() throws {
        XCTAssertEqual(try Day9(input: Day9.sample).solvePart1(), 13)
    }

    func test_part1_solution() throws {
        XCTAssertEqual(try Day9().solvePart1(), 6357)
    }

    func test_part2_test() throws {
        XCTAssertEqual(try Day9(input: Day9.samplePart2).solvePart2(), 36)
    }

    func test_part2_solution() throws {
        XCTAssertEqual(try Day9().solvePart2(), 2627)
    }
}
