import AdventOfCodeKit
import Parsing

public struct Day10 {
    public static let sample = """
        addx 15
        addx -11
        addx 6
        addx -3
        addx 5
        addx -1
        addx -8
        addx 13
        addx 4
        noop
        addx -1
        addx 5
        addx -1
        addx 5
        addx -1
        addx 5
        addx -1
        addx 5
        addx -1
        addx -35
        addx 1
        addx 24
        addx -19
        addx 1
        addx 16
        addx -11
        noop
        noop
        addx 21
        addx -15
        noop
        noop
        addx -3
        addx 9
        addx 1
        addx -3
        addx 8
        addx 1
        addx 5
        noop
        noop
        noop
        noop
        noop
        addx -36
        noop
        addx 1
        addx 7
        noop
        noop
        noop
        addx 2
        addx 6
        noop
        noop
        noop
        noop
        noop
        addx 1
        noop
        noop
        addx 7
        addx 1
        noop
        addx -13
        addx 13
        addx 7
        noop
        addx 1
        addx -33
        noop
        noop
        noop
        addx 2
        noop
        noop
        noop
        addx 8
        noop
        addx -1
        addx 2
        addx 1
        noop
        addx 17
        addx -9
        addx 1
        addx 1
        addx -3
        addx 11
        noop
        noop
        addx 1
        noop
        addx 1
        noop
        noop
        addx -13
        addx -19
        addx 1
        addx 3
        addx 26
        addx -30
        addx 12
        addx -1
        addx 3
        addx 1
        noop
        noop
        noop
        addx -9
        addx 18
        addx 1
        addx 2
        noop
        noop
        addx 9
        noop
        noop
        noop
        addx -1
        addx 2
        addx -37
        addx 1
        addx 3
        noop
        addx 15
        addx -21
        addx 22
        addx -6
        addx 1
        noop
        addx 2
        addx 1
        noop
        addx -10
        noop
        noop
        addx 20
        addx 1
        addx 2
        addx 2
        addx -6
        addx -11
        noop
        noop
        noop
        """

    public let input: String

    public init(
        input: String? = nil
    ) {
        if let input {
            self.input = input
        } else if let input = try? Input.day(10) {
            self.input = input
        } else {
            self.input = Self.sample
        }
    }

    enum Instruction {
        case noop
        case addx(Int)
    }

    let parser = Many {
        OneOf {
            Parse { "noop" }.map { Instruction.noop }
            Parse {
                "addx "
                Int.parser()
            }.map { Instruction.addx($0) }
        }
    } separator: {
        "\n"
    }

    struct Program {
        let instructions: [Instruction]
        let registerValuesByCycle: [Int]

        init(
            instructions: [Instruction]
        ) {
            self.instructions = instructions

            struct State {
                var signalStrength = 1
                var addValue: Int?
                var instructionIndex = -1
            }

            self.registerValuesByCycle = Array(
                sequence(state: State()) { state -> Int? in
                    if let value = state.addValue {
                        let currentStrength = state.signalStrength
                        state.signalStrength += value
                        state.addValue = nil
                        state.instructionIndex += 1
                        return currentStrength
                    }

                    let nextInstructionIndex = state.instructionIndex + 1
                    guard instructions.indices.contains(nextInstructionIndex) else { return nil }

                    switch instructions[nextInstructionIndex] {
                    case .noop:
                        state.instructionIndex += 1
                    case .addx(let value):
                        state.addValue = value
                    }

                    return state.signalStrength
                })
        }

        func print(width: Int, height: Int) -> String {
            var matrix = Matrix<Character>(repeating: ".", width: 40, height: 6)
            for (cycle, registerValue) in registerValuesByCycle.enumerated() {
                let (quotient, remainder) = cycle.quotientAndRemainder(dividingBy: 40)
                if ((registerValue - 1)...(registerValue + 1)).contains(remainder) {
                    matrix.set(value: "#", x: remainder, y: quotient)
                }
            }
            return matrix.debugDescription
        }
    }

    public func solvePart1() throws -> Int {
        let instructions = try parser.parse(input)
        let program = Program(instructions: instructions)
        return stride(from: 20, to: program.registerValuesByCycle.endIndex, by: 40).reduce(0) { acc, index in
            return acc + program.registerValuesByCycle[index - 1] * index
        }
    }

    public func solvePart2() throws -> String {
        let instructions = try parser.parse(input)
        let program = Program(instructions: instructions)
        return program.print(width: 40, height: 6)
    }
}
