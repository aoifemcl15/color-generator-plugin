import Foundation
import ColorGeneratorCore


let arguments = ProcessInfo().arguments

do {
    try ColorGenerator.run(arguments: arguments)
}
catch {
    NSLog("Error while generating colours \(error)")
}
