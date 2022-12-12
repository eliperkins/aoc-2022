// swiftlint:disable identifier_name
public struct Matrix<T>: CustomDebugStringConvertible {
    private(set) var _rows: [[T]]
    private(set) var _columns: [[T]]

    public init(
        _ xs: [[T]]
    ) {
        _rows = xs
        let columns = xs[0].indices.map { index in
            xs.map { $0[index] }
        }
        self._columns = columns
    }

    public init(
        repeating: T,
        width: Int,
        height: Int
    ) {
        self.init([[T]](repeating: [T](repeating: repeating, count: width), count: height))
    }

    public var rows: [[T]] {
        _rows
    }

    public var columns: [[T]] {
        _columns
    }

    public func atPosition(x: Int, y: Int) -> T? {
        if rows.indices.contains(y) {
            let row = rows[y]
            if row.indices.contains(x) {
                return row[x]
            }
        }

        return nil
    }

    public mutating func set(value: T, x: Int, y: Int) {
        if rows.indices.contains(y) {
            let row = rows[y]
            if row.indices.contains(x) {
                _rows[y][x] = value
                _columns[x][y] = value
            }
        }
    }

    public func forEachPosition(_ fn: (T, (x: Int, y: Int)) -> Void) {
        rows.enumerated().forEach { (rowIndex, row) in
            row.enumerated().forEach { (columnIndex, item) in
                fn(item, (x: columnIndex, y: rowIndex))
            }
        }
    }

    public func map<U>(_ fn: (T, (x: Int, y: Int)) -> U) -> Matrix<U> {
        Matrix<U>(
            rows.enumerated().map { (rowIndex, row) in
                row.enumerated().map { (columnIndex, item) in
                    fn(item, (x: columnIndex, y: rowIndex))
                }
            }
        )
    }

    public func collect(_ predicate: (T, (x: Int, y: Int)) -> Bool) -> [T] {
        var output = [T]()
        rows.enumerated().forEach { (rowIndex, row) in
            row.enumerated().forEach { (columnIndex, item) in
                if predicate(item, (x: columnIndex, y: rowIndex)) {
                    output.append(item)
                }
            }
        }
        return output
    }

    public func collectLocations(_ predicate: (T, (x: Int, y: Int)) -> Bool) -> [(T, (x: Int, y: Int))] {
        var output = [(T, (x: Int, y: Int))]()
        rows.enumerated().forEach { (rowIndex, row) in
            row.enumerated().forEach { (columnIndex, item) in
                if predicate(item, (x: columnIndex, y: rowIndex)) {
                    output.append((item, (x: columnIndex, y: rowIndex)))
                }
            }
        }
        return output
    }

    public func first(where fn: (T) -> Bool) -> T? {
        for row in rows {
            for item in row where fn(item) {
                return item
            }
        }
        return nil
    }

    public func firstPosition(where fn: (T) -> Bool) -> (x: Int, y: Int)? {
        for (y, row) in rows.enumerated() {
            for (x, item) in row.enumerated() where fn(item) {
                return (x: x, y: y)
            }
        }
        return nil
    }
}

extension Matrix {
    public var debugDescription: String {
        rows.debugDescription
    }
}

extension Matrix where T == String {
    public var debugDescription: String {
        rows.map { $0.joined() }.joined(separator: "\n")
    }
}

extension Matrix where T == Character {
    init(
        string: String
    ) throws {
        self.init(string.lines.map(Array.init))
    }

    public var debugDescription: String {
        rows.map { String($0) }.joined(separator: "\n")
    }
}

extension Matrix: Equatable where T: Equatable {}
extension Matrix: Hashable where T: Hashable {}
