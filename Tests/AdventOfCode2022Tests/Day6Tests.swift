import AdventOfCode2022
import XCTest

final class Day6Tests: XCTestCase {
    func test_part1_test() throws {
        XCTAssertEqual(try Day6(input: Day6.sample).solvePart1(), 7)
        XCTAssertEqual(try Day6(input: "bvwbjplbgvbhsrlpgdmjqwftvncz").solvePart1(), 5)
        XCTAssertEqual(try Day6(input: "nppdvjthqldpwncqszvftbrmjlhg").solvePart1(), 6)
        XCTAssertEqual(try Day6(input: "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg").solvePart1(), 10)
        XCTAssertEqual(try Day6(input: "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw").solvePart1(), 11)
    }

    func test_part1_solution() throws {
        XCTAssertEqual(try Day6().solvePart1(), 1658)
    }

    func test_part2_test() throws {
        XCTAssertEqual(try Day6(input: Day6.sample).solvePart2(), 19)
        XCTAssertEqual(try Day6(input: "bvwbjplbgvbhsrlpgdmjqwftvncz").solvePart2(), 23)
        XCTAssertEqual(try Day6(input: "nppdvjthqldpwncqszvftbrmjlhg").solvePart2(), 23)
        XCTAssertEqual(try Day6(input: "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg").solvePart2(), 29)
        XCTAssertEqual(try Day6(input: "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw").solvePart2(), 26)
    }

    func test_part2_solution() throws {
        XCTAssertEqual(try Day6().solvePart2(), 2260)
    }
}
