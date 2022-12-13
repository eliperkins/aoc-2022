import AdventOfCode2022
import XCTest

final class Day13Tests: XCTestCase {
    func test_part1_test() throws {
        XCTAssertEqual(try Day13(input: Day13.sample).solvePart1(), 13)
    }

    func test_part1_solution() throws {
        XCTAssertEqual(try Day13().solvePart1(), 5340)
    }

    func test_part2_test() throws {
        XCTAssertEqual(try Day13(input: Day13.sample).solvePart2(), 140)
    }

    func test_part2_solution() throws {
        XCTAssertEqual(try Day13().solvePart2(), 21276)
    }
}
