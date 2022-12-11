import AdventOfCode2022
import XCTest

final class Day11Tests: XCTestCase {
    func test_part1_test() throws {
        XCTAssertEqual(try Day11(input: Day11.sample).solvePart1(), 10605)
    }

    func test_part1_solution() throws {
        XCTAssertEqual(try Day11().solvePart1(), 182293)
    }

    func test_part2_test() throws {
        XCTAssertEqual(try Day11(input: Day11.sample).solvePart2(), 2_713_310_158)
    }

    func test_part2_solution() throws {
        XCTAssertEqual(try Day11().solvePart2(), 54_832_778_815)
    }
}
