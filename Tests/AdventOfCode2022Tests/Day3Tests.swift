import AdventOfCode2022
import XCTest

final class Day3Tests: XCTestCase {
    func test_part1_test() throws {
        XCTAssertEqual(try Day3(input: Day3.sample).solvePart1(), 157)
    }

    func test_part1_solution() throws {
        XCTAssertEqual(try Day3().solvePart1(), 7746)
    }

    func test_part2_test() throws {
        XCTAssertEqual(try Day3(input: Day3.sample).solvePart2(), 70)
    }

    func test_part2_solution() throws {
        XCTAssertEqual(try Day3().solvePart2(), 2604)
    }
}
