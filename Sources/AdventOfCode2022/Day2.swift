import AdventOfCodeKit
private protocol Scorable {
    var scoreValue: Int { get }
}

public struct Day2 {
    public static let sample = """
        A Y
        B X
        C Z
        """

    public let input: String

    enum OpponentMove: String {
        case rock = "A"
        case paper = "B"
        case scissors = "C"

        func playerMove(for outcome: Outcome) -> PlayerMove {
            switch (self, outcome) {
            case (.rock, .draw), (.paper, .lose), (.scissors, .win):
                return .rock
            case (.rock, .win), (.paper, .draw), (.scissors, .lose):
                return .paper
            case (.rock, .lose), (.paper, .win), (.scissors, .draw):
                return .scissors
            }
        }
    }

    enum PlayerMove: String, Scorable {
        case rock = "X"
        case paper = "Y"
        case scissors = "Z"

        var scoreValue: Int {
            switch self {
            case .rock: return 1
            case .paper: return 2
            case .scissors: return 3
            }
        }
    }

    enum Outcome: Scorable {
        case win
        case draw
        case lose

        init?(
            decodedValue: String
        ) {
            switch decodedValue {
            case "X":
                self = .lose
            case "Y":
                self = .draw
            case "Z":
                self = .win
            default:
                return nil
            }
        }

        var scoreValue: Int {
            switch self {
            case .win: return 6
            case .lose: return 0
            case .draw: return 3
            }
        }
    }

    public init(
        input: String? = nil
    ) {
        if let input {
            self.input = input
        } else if let input = try? Input.day(2) {
            self.input = input
        } else {
            self.input = Self.sample
        }
    }

    struct Matchup: Scorable {
        let opponentMove: OpponentMove
        let playerMove: PlayerMove

        var outcome: Outcome {
            switch (opponentMove, playerMove) {
            case (.rock, .paper), (.paper, .scissors), (.scissors, .rock):
                return .win
            case (.rock, .rock), (.paper, .paper), (.scissors, .scissors):
                return .draw
            case (.paper, .rock), (.scissors, .paper), (.rock, .scissors):
                return .lose
            }
        }

        var scoreValue: Int {
            outcome.scoreValue + playerMove.scoreValue
        }
    }

        input.lines
            .compactMap { line -> Matchup? in
                let xs = line.split(separator: " ").map(String.init)
                guard let opponentMove = xs.first.flatMap(OpponentMove.init),
                    let playerMove = xs.last.flatMap(PlayerMove.init)
                else {
                    return nil
                }
                return Matchup(opponentMove: opponentMove, playerMove: playerMove)
    public func solvePart1() throws -> Int {
            }
            .map(\.scoreValue)
            .reduce(0, +)
    }

        input.lines
            .compactMap { line -> Matchup? in
                let xs = line.split(separator: " ").map(String.init)
                guard let opponentMove = xs.first.flatMap(OpponentMove.init),
                    let outcome = xs.last.flatMap(Outcome.init)
                else {
                    return nil
                }
    public func solvePart2() throws -> Int {
                let playerMove = opponentMove.playerMove(for: outcome)
                return Matchup(opponentMove: opponentMove, playerMove: playerMove)
            }
            .map(\.scoreValue)
            .reduce(0, +)
    }
}
