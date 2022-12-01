import Algorithms

extension String {
    var paragraphs: [ArraySlice<String>] {
        lines.chunked(by: { _, str in !str.isEmpty })
    }
}
