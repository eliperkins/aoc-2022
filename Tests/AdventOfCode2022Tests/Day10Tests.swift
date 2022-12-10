import AdventOfCode2022
import XCTest

final class Day10Tests: XCTestCase {
    func test_part1_test() throws {
        XCTAssertEqual(try Day10(input: Day10.sample).solvePart1(), 13140)
    }

    func test_part1_solution() throws {
        XCTAssertEqual(try Day10().solvePart1(), 13060)
    }

    func test_part2_test() throws {
        XCTAssertEqual(
            try Day10(input: Day10.sample).solvePart2(),
            """
            ##..##..##..##..##..##..##..##..##..##..
            ###...###...###...###...###...###...###.
            ####....####....####....####....####....
            #####.....#####.....#####.....#####.....
            ######......######......######......####
            #######.......#######.......#######.....
            """)
    }

    func test_part2_solution() throws {
        XCTAssertEqual(
            try Day10().solvePart2(),
            """
            ####...##.#..#.###..#..#.#....###..####.
            #.......#.#..#.#..#.#..#.#....#..#....#.
            ###.....#.#..#.###..#..#.#....#..#...#..
            #.......#.#..#.#..#.#..#.#....###...#...
            #....#..#.#..#.#..#.#..#.#....#.#..#....
            #.....##...##..###...##..####.#..#.####.
            """)
    }
}
