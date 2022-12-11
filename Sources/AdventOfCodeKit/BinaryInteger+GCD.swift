extension BinaryInteger {
    public static func gcd(_ a: Self, _ b: Self) -> Self {
        let remainder = a % b
        guard remainder != 0 else {
            return b
        }
        return gcd(b, remainder)
    }

    public static func gcd(_ xs: [Self]) -> Self {
        xs.reduce(0, gcd)
    }

    public static func lcm(_ a: Self, _ b: Self) -> Self {
        a * b / gcd(a, b)
    }

    public static func lcm(_ xs: [Self]) -> Self {
        xs.reduce(1, lcm)
    }
}

extension Sequence where Element: BinaryInteger {
    public func gcd() -> Element {
        reduce(0, Element.gcd)
    }

    public func lcm() -> Element {
        reduce(1, Element.lcm)
    }
}
