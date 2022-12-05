import AdventOfCode2022
import XCTest

final class Day4Tests: XCTestCase {
    func test_part1_test() throws {
        XCTAssertEqual(try Day4(input: Day4.sample).solvePart1(), 2)
    }

    func test_part1_solution() throws {
        XCTAssertEqual(try Day4().solvePart1(), 542)
    }

    func test_part2_test() throws {
        XCTAssertEqual(try Day4(input: Day4.sample).solvePart2(), 4)
    }

    func test_part2_solution() throws {
        XCTAssertEqual(try Day4().solvePart2(), 900)
    }
}
