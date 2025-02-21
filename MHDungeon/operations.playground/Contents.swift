//import UIKit

var greeting = "Hello, playground"
var test: Bool = true

func SustainabilityTest(_ sustain: inout Bool) -> Void {
    sustain.toggle()
}

SustainabilityTest(&test)

print("Here is the result of the first test:", test)

SustainabilityTest(&test)

print("Here is the result of the second test:", test)
