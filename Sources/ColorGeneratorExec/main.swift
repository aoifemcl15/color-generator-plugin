import Foundation
import ColorGeneratorCore

// This will hold the code required to

// Extract arguments as input and output files
// For testing purposes let's just print them out

let arguments = ProcessInfo().arguments

do {
    try ColorGeneratorExisting.run(arguments: arguments)
}
catch {
    NSLog("Error while generating colours \(error)")
}
