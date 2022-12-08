import AdventOfCodeKit
import Foundation

public struct Day8 {
    public static let sample = """
        30373
        25512
        65332
        33549
        35390
        """

    public let input: String

    public init(
        input: String? = nil
    ) {
        if let input {
            self.input = input
        } else if let input = try? Input.day(8) {
            self.input = input
        } else {
            self.input = Self.sample
        }
    }

    struct Tree: Hashable {
        let height: Int
        let id: UUID

        init(
            height: Int, id: UUID = UUID()
        ) {
            self.height = height
            self.id = id
        }
    }

    public func solvePart1() throws -> Int {
        let matrix = Matrix<Tree>(
            input.lines.map { line in
                line.compactMap {
                    guard let height = Int(String($0)) else { return nil }
                    return Tree(height: height)
                }
            })
        var visibleTrees = Set<Tree>()

        [matrix.rows, matrix.columns, matrix.rows.map { $0.reversed() }, matrix.columns.map { $0.reversed() }]
            .flatMap { $0 }
            .forEach { row in
                var maxTree: Tree?
                for tree in row {
                    if let max = maxTree {
                        if max.height < tree.height {
                            visibleTrees.insert(tree)
                        }
                        if tree.height > max.height {
                            maxTree = tree
                        }
                    } else {
                        visibleTrees.insert(tree)
                        maxTree = tree
                    }
                }
            }

        return visibleTrees.count
    }

    public func solvePart2() throws -> Int {
        let matrix = Matrix<Tree>(
            input.lines.map { line in
                line.compactMap {
                    guard let height = Int(String($0)) else { return nil }
                    return Tree(height: height)
                }
            })

        func scenicScore(position: (x: Int, y: Int)) -> Int {
            guard position.x > 0, position.y > 0, position.x < matrix.columns.count - 1,
                position.y < matrix.rows.count - 1
            else {
                return 0
            }

            func count(trees: [Tree]) -> Int {
                if trees.isEmpty {
                    return 0
                }

                let viewingSpot = trees[0]
                var treeCount = 0
                for tree in trees.dropFirst() {
                    treeCount += 1

                    if tree.height >= viewingSpot.height {
                        return treeCount
                    }
                }
                return treeCount
            }

            let up = count(trees: matrix.columns[position.x][0...position.y].reversed())
            let down = count(trees: Array(matrix.columns[position.x][position.y...matrix.columns.endIndex - 1]))
            let left = count(trees: matrix.rows[position.y][0...position.x].reversed())
            let right = count(trees: Array(matrix.rows[position.y][position.x...matrix.rows.endIndex - 1]))
            return [up, down, left, right].reduce(1, *)
        }

        var maxScore = 0
        matrix.forEachPosition { _, position in
            let score = scenicScore(position: position)
            if maxScore < score {
                maxScore = score
            }
        }

        return maxScore
    }
}
