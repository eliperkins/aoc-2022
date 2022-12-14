import AdventOfCode2022
import XCTest

final class Day14Tests: XCTestCase {
    func test_part1_test() throws {
        XCTAssertEqual(try Day14(input: Day14.sample).solvePart1(), 24)
    }

    func test_part1_solution() throws {
        XCTAssertEqual(try Day14().solvePart1(), 655)
    }

    func test_part2_test() throws {
        XCTAssertEqual(try Day14(input: Day14.sample).solvePart2(), 93)
    }

    func test_part2_solution() throws {
        XCTAssertEqual(try Day14().solvePart2(), 26484)
    }
}
