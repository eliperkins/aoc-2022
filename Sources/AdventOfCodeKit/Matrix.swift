public struct Matrix<T> {
    private(set) var storage: [[T]]
    private let _columns: [[T]]

    public init(
        _ xs: [[T]]
    ) {
        storage = xs
        let columns = xs[0].indices.map { index in
            xs.map { $0[index] }
        }
        self._columns = columns
    }

    public var rows: [[T]] {
        storage
    }

    public var columns: [[T]] {
        _columns
    }

    public func atPosition(x: Int, y: Int) -> T? {
        if storage.indices.contains(y) {
            let row = storage[y]
            if row.indices.contains(x) {
                return row[x]
            }
        }

        return nil
    }

    mutating func set(value: T, x: Int, y: Int) {
        if storage.indices.contains(y) {
            let row = storage[y]
            if row.indices.contains(x) {
                storage[y][x] = value
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
}
