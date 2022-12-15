import AdventOfCode2022
import XCTest

final class Day15Tests: XCTestCase {
    func test_part1_test() throws {
        XCTAssertEqual(try Day15(input: Day15.sample).solvePart1(row: 10), 26)
    }

    func test_part1_solution() throws {
        XCTAssertEqual(try Day15().solvePart1(row: 2_000_000), 5_144_286)
    }

    func test_part2_test() throws {
        XCTAssertEqual(try Day15(input: Day15.sample).solvePart2(searchSpace: 20), 56_000_011)
    }

    func test_part2_solution() throws {
        XCTAssertEqual(try Day15().solvePart2(searchSpace: 4_000_000), 10_229_191_267_339)
    }
}
