[![Build Status](https://travis-ci.org/andersonlucasg3/Swift.Json.svg?branch=master)](https://travis-ci.org/andersonlucasg3/Swift.Json)

# Swift.Json
Json auto-parsing for Swift.

##### Examples
For using the JsonParser and JsonWriter classes you just need to declare your swift classes where all the properties are `dynamic` and the class **MUST** extend from `NSObject`.
Other thing is that `Obj-c` representable objects may be optional, but non `obj-c` representable objects **MUST** be defined non optional.
But the `dynamic` diretive will obligate you to define it right.

###### Writing example:
Example of the implementation for converting objects to string.
```swift
import Swift_Json // very important

class Employee: NSObject {
    fileprivate(set) dynamic var name: String?
    fileprivate(set) dynamic var age: Int = 0
}

class Boss: Employee {
    fileprivate(set) dynamic var employees: [Employee]?
}

let employee1: Employee = Employee()
employee1.name = "John Apple Juice"
employee1.age = 35

let boss: Boss = Boss()
boss.name = "Steve James Apple Orange Juice"
boss.age = 65
boss.employees?.append(employee1)

let jsonString: String = JsonWriter.write(boss)
```

###### Parsing example:
Example of the implementation for converting string to objects.
Obs: Using the same classes from above.
```swift
let jsonString: String = // json string

let boss: Boss = JsonParser.parse(string: jsonString)

assert(boss.name == "Steve James Apple Orange Juice")
assert(boss.age == 65)
assert(boss.employees![0].name == "John Apple Juice")
assert(boss.employees![0].age == 35)
```

Any doubts, post an issue or create a pull request. Pull requests are welcome.
Thanks.