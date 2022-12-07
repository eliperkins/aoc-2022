private protocol FileSystemTraversable {
    var name: String { get }
    var size: Int { get }
}

public struct Day7 {
    public static let sample = """
        $ cd /
        $ ls
        dir a
        14848514 b.txt
        8504156 c.dat
        dir d
        $ cd a
        $ ls
        dir e
        29116 f
        2557 g
        62596 h.lst
        $ cd e
        $ ls
        584 i
        $ cd ..
        $ cd ..
        $ cd d
        $ ls
        4060174 j
        8033020 d.log
        5626152 d.ext
        7214296 k
        """

    public let input: String

    public init(
        input: String? = nil
    ) {
        if let input {
            self.input = input
        } else if let input = try? Input.day(7) {
            self.input = input
        } else {
            self.input = Self.sample
        }
    }

    final class Directory: FileSystemTraversable {
        let name: String
        weak var parentDirectory: Directory?
        private(set) var entries: [String: TreeEntry]

        init(
            name: String, entries: [String: Day7.TreeEntry]
        ) {
            self.name = name
            self.entries = entries
        }

        var size: Int {
            entries.values
                .map(\.size)
                .reduce(0, +)
        }

        func appending(_ treeEntry: TreeEntry) {
            entries[treeEntry.name] = treeEntry
            if case let .directory(childDir) = treeEntry {
                childDir.parentDirectory = self
            }
        }

        func mapDirectories<T>(_ f: (Directory) -> T) -> [T] {
            var xs = [T]()
            xs.append(f(self))
            entries.values.forEach {
                switch $0 {
                case .directory(let dir):
                    xs.append(contentsOf: dir.mapDirectories(f))
                case .blob:
                    break
                }
            }
            return xs
        }

        func compactMapDirectories<T>(_ f: (Directory) -> T?) -> [T] {
            var xs = [T]()
            if let foo = f(self) {
                xs.append(foo)
            }
            entries.values.forEach {
                switch $0 {
                case .directory(let dir):
                    xs.append(contentsOf: dir.compactMapDirectories(f))
                case .blob:
                    break
                }
            }
            return xs
        }
    }

    struct Blob: FileSystemTraversable {
        let name: String
        let size: Int
    }

    enum TreeEntry: FileSystemTraversable {
        case directory(Directory)
        case blob(Blob)

        var name: String {
            switch self {
            case .directory(let directory): return directory.name
            case .blob(let blob): return blob.name
            }
        }

        var size: Int {
            switch self {
            case .directory(let directory): return directory.size
            case .blob(let blob): return blob.size
            }
        }
    }

    enum Command {
        case cd(path: String)
        case ls
    }

    enum Line {
        case command(Command)
        case treeEntry(TreeEntry)

        init(
            _ line: String
        ) {
            let parts = line.split(separator: " ")
            switch (parts.first, parts.count) {
            case ("$", 2) where parts.last == "ls":
                self = .command(.ls)
            case ("$", 3) where parts[1] == "cd":
                self = .command(.cd(path: String(parts.last!)))
            case (_, 2) where parts.first == "dir":
                self = .treeEntry(.directory(.init(name: String(parts.last!), entries: [:])))
            case (_, 2):
                self = .treeEntry(.blob(.init(name: String(parts.last!), size: Int(String(parts.first!))!)))
            default:
                fatalError()
            }
        }
    }

    final class WorkingState {
        let rootDirectory = Directory(name: "/", entries: [:])
        private var workingDirectory: Directory?

        init(
            lines: [Line]
        ) {
            self.workingDirectory = rootDirectory
            for line in lines {
                process(line)
            }
        }

        func process(_ line: Line) {
            switch line {
            case .treeEntry(let treeEntry):
                workingDirectory?.appending(treeEntry)
            case .command(let command):
                process(command)
            }
        }

        func process(_ command: Command) {
            switch command {
            case .cd(let path):
                if path == ".." {
                    workingDirectory = workingDirectory?.parentDirectory
                } else if case let .directory(dir) = workingDirectory?.entries[path] {
                    workingDirectory = dir
                }
            case .ls:
                break
            }
        }
    }

    public func solvePart1() throws -> Int {
        let lines = input.lines.map(Line.init)
        let state = WorkingState(lines: lines)
        return state.rootDirectory
            .compactMapDirectories { dir -> Int? in
                if dir.size < 100000 {
                    return dir.size
                }
                return nil
            }
            .sum()
    }

    public func solvePart2() throws -> Int {
        let lines = input.lines.map(Line.init)
        let state = WorkingState(lines: lines)
        let sizes = state.rootDirectory.mapDirectories { dir in
            dir.size
        }
        let usedSpace = state.rootDirectory.size
        let capacity = 70_000_000
        let freeSpaceNeeded = 30_000_000
        let unusedSpace = capacity - usedSpace
        return sizes.filter { unusedSpace + $0 > freeSpaceNeeded }.min() ?? 0
    }
}
