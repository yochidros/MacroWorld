import Foundation
import MacroWorld

let a = 17
let b = 25

let (result, code) = #stringify(a + b)

print("The value \(result) was produced by the code \"\(code)\"")

// #MARK: Int Macro
let i = #intify("0")
print("the value \(i)")

// #MARK: URL Macro

let url1 = #url("https://apple.com/")
let url2 = #url("https://")
let url3 = #url("https/")
let url4 = #url("http://hogehoge.jp")
print(url1, url2, url3, url4)

let vurl1 = #validatedURL("https://apple.com/", strict: true)
let vurl2 = #validatedURL("https://", strict: false)
let vurl3 = #validatedURL("https/", strict: false)
let vurl4 = #validatedURL("http://hogehoge.jp")
let vurl5 = #validatedURL("hogahoige", strict: false)

print(vurl1, vurl2, vurl3, vurl4, vurl5)


// Error: Global freestanding macros not yet supported in script mode
//#Animal(name: "Dog🐶")

struct FreeDeclSample {
    #Animal(typeName: "Dog")
    #Animal(typeName: "Cat")
    #Animal(typeName: "Snake🐍")

    #customWarning("にゃーーーーーーーーーーーにゃーー")
    static func run(animal: some AnimalProtocol) async throws {
        animal.say()

        try await Task.sleep(for: Duration.milliseconds(.random(in: 100..<1000)))

        animal.sayAgain()
    }
}

// precheck calc

async let dog: () = FreeDeclSample.run(animal: FreeDeclSample.Dog(name: "🐶"))
async let cat: () = FreeDeclSample.run(animal: FreeDeclSample.Cat(name: "🐈"))
async let snake: () = FreeDeclSample.run(animal: FreeDeclSample.Snake🐍(name: "🐍"))

try await (_, _, _) = (dog, cat, snake)

struct AttachedSample {
    private var _name: String = ""
    @wooAccessor
    var name: String
}

var accessor = AttachedSample()
accessor.name = "newDog"
print(accessor.name)
