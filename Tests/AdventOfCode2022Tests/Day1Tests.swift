import AdventOfCode2022
import XCTest

final class Day1Tests: XCTestCase {
    func test_part1_test() throws {
        XCTAssertEqual(try Day1(input: Day1.sample).solvePart1(), 24000)
    }

    func test_part1_solution() throws {
        XCTAssertEqual(try Day1().solvePart1(), 70720)
    }

    func test_part2_test() throws {
        XCTAssertEqual(try Day1(input: Day1.sample).solvePart2(), 45000)
    }

    func test_part2_solution() throws {
        XCTAssertEqual(try Day1().solvePart2(), 207148)
    }
}
