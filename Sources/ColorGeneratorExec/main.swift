import Foundation
import ColorGeneratorCore

// This will hold the code required to

// Extract arguments as input and output files
// For testing purposes let's just print them out

let arguments = ProcessInfo().arguments

try ColorGeneratorExisting.run(arguments: arguments)

print(arguments[0])
print(arguments[1])
print(arguments[2])
