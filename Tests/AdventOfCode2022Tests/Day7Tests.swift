import AdventOfCode2022
import XCTest

final class Day7Tests: XCTestCase {
    func test_part1_test() throws {
        XCTAssertEqual(try Day7(input: Day7.sample).solvePart1(), 95437)
    }

    func test_part1_solution() throws {
        XCTAssertEqual(try Day7().solvePart1(), 1_477_771)
    }

    func test_part2_test() throws {
        XCTAssertEqual(try Day7(input: Day7.sample).solvePart2(), 24_933_642)
    }

    func test_part2_solution() throws {
        XCTAssertEqual(try Day7().solvePart2(), 3_579_501)
    }
}
