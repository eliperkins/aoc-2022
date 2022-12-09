public struct Point: Hashable {
    public var x: Int
    public var y: Int

    public init(
        x: Int, y: Int
    ) {
        self.x = x
        self.y = y
    }

    public init(
        _ coordinates: (Int, Int)
    ) {
        self.x = coordinates.0
        self.y = coordinates.1
    }

    public var adjecent: Set<Point> {
        [
            Point(x: x + 1, y: y),
            Point(x: x + 1, y: y + 1),
            Point(x: x + 1, y: y - 1),
            Point(x: x - 1, y: y),
            Point(x: x - 1, y: y + 1),
            Point(x: x - 1, y: y - 1),
            Point(x: x, y: y + 1),
            Point(x: x, y: y - 1),
        ]
    }
}
