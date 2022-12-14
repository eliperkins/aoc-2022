import AdventOfCode2022
import XCTest

final class Day2Tests: XCTestCase {
    func test_part1_test() throws {
        XCTAssertEqual(try Day2(input: Day2.sample).solvePart1(), 15)
    }

    func test_part1_solution() throws {
        XCTAssertEqual(try Day2().solvePart1(), 13484)
    }

    func test_part2_test() throws {
        XCTAssertEqual(try Day2(input: Day2.sample).solvePart2(), 12)
    }

    func test_part2_solution() throws {
        XCTAssertEqual(try Day2().solvePart2(), 13433)
    }
}
