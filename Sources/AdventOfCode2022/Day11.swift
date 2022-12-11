import DequeModule
import Parsing

public struct Day11 {
    public static let sample = """
        Monkey 0:
          Starting items: 79, 98
          Operation: new = old * 19
          Test: divisible by 23
            If true: throw to monkey 2
            If false: throw to monkey 3

        Monkey 1:
          Starting items: 54, 65, 75, 74
          Operation: new = old + 6
          Test: divisible by 19
            If true: throw to monkey 2
            If false: throw to monkey 0

        Monkey 2:
          Starting items: 79, 60, 97
          Operation: new = old * old
          Test: divisible by 13
            If true: throw to monkey 1
            If false: throw to monkey 3

        Monkey 3:
          Starting items: 74
          Operation: new = old + 3
          Test: divisible by 17
            If true: throw to monkey 0
            If false: throw to monkey 1
        """

    final class Monkey {
        var items: Deque<Int>
        let operation: (Int) -> Int
        let test: (Int) -> (Int, Int)
        let divisor: Int
        var inspections = 0

        init(
            items: [Int], divisor: Int, operation: @escaping (Int) -> Int, test: @escaping (Int) -> (Int, Int)
        ) {
            self.items = Deque(items)
            self.divisor = divisor
            self.operation = operation
            self.test = test
        }

        func inspect(_ worryValue: Int, reducingBy fn: (Int) -> Int) -> (Int, Int) {
            inspections += 1
            return test(fn(worryValue))
        }
    }

    public let input: String

    public init(
        input: String? = nil
    ) {
        if let input {
            self.input = input
        } else if let input = try? Input.day(11) {
            self.input = input
        } else {
            self.input = Self.sample
        }
    }

    enum OperationValue {
        case old
        case const(Int)
    }

    // swiftlint:disable:next function_body_length
    func parseMonkeys() throws -> [Monkey] {
        let argumentParser = OneOf {
            Int.parser().map(OperationValue.const)
            "old".map { OperationValue.old }
        }
        let operatorParser = OneOf {
            "*".map { { (x: Int, y: Int) in x * y } }
            "/".map { { (x: Int, y: Int) in x / y } }
            "+".map { { (x: Int, y: Int) in x + y } }
            "-".map { { (x: Int, y: Int) in x - y } }
        }
        let operationParser = Parse {
            "  Operation: new = "
            argumentParser
            Whitespace(1)
            operatorParser
            Whitespace(1)
            argumentParser
        }
        let divisorParser = Parse {
            "  Test: divisible by "
            Int.parser()
        }
        let monkeyParser = Parse { _, startingItems, operation, divisor, trueMonkey, falseMonkey in
            return Monkey(items: startingItems, divisor: divisor) { old in
                switch operation {
                case (OperationValue.old, let operation, OperationValue.old):
                    return operation(old, old)
                case (OperationValue.const(let x), let operation, OperationValue.old):
                    return operation(x, old)
                case (OperationValue.old, let operation, OperationValue.const(let x)):
                    return operation(old, x)
                case (OperationValue.const(let x), let operation, OperationValue.const(let y)):
                    return operation(x, y)
                }
            } test: { value in
                value.isMultiple(of: divisor)
                    ? (value, trueMonkey)
                    : (value, falseMonkey)
            }
        } with: {
            "Monkey "
            Int.parser()
            ":"
            "\n"
            "  Starting items: "
            Many {
                Int.parser()
            } separator: {
                ", "
            }
            "\n"
            operationParser
            "\n"
            divisorParser
            "\n"
            "    If true: throw to monkey "
            Int.parser()
            "\n"
            "    If false: throw to monkey "
            Int.parser()
        }

        let parser = Many {
            monkeyParser
        } separator: {
            "\n\n"
        }

        return try parser.parse(input)
    }

    public func solvePart1() throws -> Int {
        let monkeys = try parseMonkeys()
        for _ in 0..<20 {
            for monkey in monkeys {
                while let item = monkey.items.popFirst() {
                    let currentWorryLevel = monkey.operation(item)
                    let (worryLevel, targetMonkey) = monkey.inspect(currentWorryLevel) {
                        $0 / 3
                    }
                    monkeys[targetMonkey].items.append(worryLevel)
                }
            }
        }
        return monkeys.map(\.inspections).sorted().suffix(2).product()
    }

    public func solvePart2() throws -> Int {
        let monkeys = try parseMonkeys()
        let lcm = monkeys.map(\.divisor).lcm()
        for _ in 0..<10_000 {
            for monkey in monkeys {
                while let item = monkey.items.popFirst() {
                    let currentWorryLevel = monkey.operation(item)
                    let (worryLevel, targetMonkey) = monkey.inspect(currentWorryLevel) {
                        $0 % lcm
                    }
                    monkeys[targetMonkey].items.append(worryLevel)
                }
            }
        }
        return monkeys.map(\.inspections).sorted().suffix(2).product()
    }
}
