import Algorithms

public struct Day6 {
    public static let sample = """
        mjqjpqmgbljsphdztnvjfqwrcgsmlb
        """

    public let input: String

    public init(
        input: String? = nil
    ) {
        if let input {
            self.input = input
        } else if let input = try? Input.day(6) {
            self.input = input
        } else {
            self.input = Self.sample
        }
    }

    func solve(size: Int) -> Int {
        guard let line = input.lines.first else { return 0 }
        guard
            let (index, _) =
                line
                .windows(ofCount: size)
                .enumerated()
                .first(where: { (_, range) in
                    Set(range).count == size
                })
        else { return 0 }
        return index + size
    }

    public func solvePart1() throws -> Int {
        solve(size: 4)
    }

    public func solvePart2() throws -> Int {
        solve(size: 14)
    }
}
