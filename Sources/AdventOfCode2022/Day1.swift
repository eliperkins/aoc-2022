import Algorithms

public struct Day1 {
    public static let sample = """
        1000
        2000
        3000

        4000

        5000
        6000

        7000
        8000
        9000

        10000
        """

    public let input: String

    public init(
        input: String = try! Input.day(1)
    ) {
        self.input = input
    }

    public func solvePart1() -> Int {
        input.lines
            .chunked(by: { _, str in !str.isEmpty })
            .map { $0.compactMap(Int.init).reduce(0, +) }
            .max() ?? 0
    }

    public func solvePart2() -> Int {
        input.lines
            .chunked(by: { _, str in !str.isEmpty })
            .map { $0.compactMap(Int.init).reduce(0, +) }
            .max(count: 3)
            .reduce(0, +)
    }
}
