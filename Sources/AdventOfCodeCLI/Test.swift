import ArgumentParser
import Foundation

struct Test: AsyncParsableCommand {
    @OptionGroup var options: Options

    static var configuration: CommandConfiguration = CommandConfiguration(
        abstract: "Tests the solution for the given day."
    )

    func run() async throws {
        let task = Process()
        task.launchPath = "/usr/bin/env"
        task.arguments = ["swift", "test", "-c", "release", "--filter", "AdventOfCode2022Tests.Day\(options.day)"]
        try task.run()
        task.waitUntilExit()

        if task.terminationStatus == 0 {
            print("􁁛  Tests passed!")
        } else {
            print("􀢄  Tests failed!")
        }
    }
}
