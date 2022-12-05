import AdventOfCode2022
import XCTest

@available(macOS 13.0, *)
final class Day5Tests: XCTestCase {
    func test_part1_test() throws {
        XCTAssertEqual(try Day5(input: Day5.sample).solvePart1(), "CMZ")
    }

    func test_part1_solution() throws {
        XCTAssertEqual(try Day5().solvePart1(), "VJSFHWGFT")
    }

    func test_part2_test() throws {
        XCTAssertEqual(try Day5(input: Day5.sample).solvePart2(), "MCD")
    }

    func test_part2_solution() throws {
        XCTAssertEqual(try Day5().solvePart2(), "LCTQFBVZV")
    }
}
