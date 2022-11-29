import ArgumentParser
import Foundation

struct Fetch: AsyncParsableCommand {
    static var configuration: CommandConfiguration = CommandConfiguration(
        abstract: "Fetches the input for the given day."
    )

    @OptionGroup var options: Options

    func run() async throws {
        guard let token = ProcessInfo.processInfo.environment["AOC_SESSION"] else {
            throw ValidationError("AOC_SESSION environment variable not set.")
        }

        let cookieStorage = HTTPCookieStorage.shared
        cookieStorage.setCookie(
            HTTPCookie(
                properties: [
                    .domain: ".adventofcode.com",
                    .path: "/",
                    .name: "session",
                    .value: token,
                ]
            )!
        )
        let url = URL(
            string: "https://adventofcode.com/\(options.year)/day/\(options.day)/input"
        )!
        let session = URLSession(configuration: .default)
        let (data, _) = try await session.data(from: url)

        guard let input = String(data: data, encoding: .utf8) else {
            throw ValidationError("Could not decode input data.")
        }

        let fileManager = FileManager.default
        let currentDirectory = fileManager.currentDirectoryPath
        let inputDirectory = URL(fileURLWithPath: currentDirectory)
            .appendingPathComponent("Sources/AdventOfCode\(options.year)/Inputs")
        try fileManager.createDirectory(
            at: inputDirectory,
            withIntermediateDirectories: true,
            attributes: nil
        )
        let inputPath = inputDirectory.appendingPathComponent("day\(options.day).txt")
        try input.write(to: inputPath, atomically: true, encoding: .utf8)
    }
}
