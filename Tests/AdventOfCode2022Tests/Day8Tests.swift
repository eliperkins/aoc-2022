import AdventOfCode2022
import XCTest

final class Day8Tests: XCTestCase {
    func test_part1_test() throws {
        XCTAssertEqual(try Day8(input: Day8.sample).solvePart1(), 21)
    }

    func test_part1_solution() throws {
        XCTAssertEqual(try Day8().solvePart1(), 1733)
    }

    func test_part2_test() throws {
        XCTAssertEqual(try Day8(input: Day8.sample).solvePart2(), 8)
    }

    func test_part2_solution() throws {
        XCTAssertEqual(try Day8().solvePart2(), 284648)
    }
}
