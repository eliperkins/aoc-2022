import AdventOfCode2022
import XCTest

final class Day12Tests: XCTestCase {
    func test_part1_test() throws {
        XCTAssertEqual(try Day12(input: Day12.sample).solvePart1(), 31)
    }

    func test_part1_solution() throws {
        XCTAssertEqual(try Day12().solvePart1(), 339)
    }

    func test_part2_test() throws {
        XCTAssertEqual(try Day12(input: Day12.sample).solvePart2(), 29)
    }

    func test_part2_solution() throws {
        XCTAssertEqual(try Day12().solvePart2(), 332)
    }
}
