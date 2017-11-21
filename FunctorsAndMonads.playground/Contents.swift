//: Functors and Monads playground.

import UIKit

// MARK: - 1.0 Basics of optional
func whatIsMyName(_ name: String) -> String {
    return "Your name is " + name
}

let labelMyName = UILabel()
let optionalName: String? = "Jimmy"

// MARK: - Unwrapping with if let
if let name = optionalName {
    labelMyName.text = whatIsMyName(name)
}

// MARK: - Unwrap with map
labelMyName.text = optionalName.map { whatIsMyName($0) }

/// MARK: - map for an array
let arrayOfInts = [2, 4, 6]

func timesTwo(value: Int) -> Int {
    return value * 2
}

// MARK: - 2. Examples arrays
print("2.0 ARRAY OF INTS PRINTED IN FOR-LOOP:")
for value in arrayOfInts {
    print(timesTwo(value: value)) // output is 4,8,12
}

print("\n2.1 ARRAY OF INTS PRINTED WITH FUNCTION AS PARAMETER:")
let doubledArray = arrayOfInts.map { timesTwo(value: $0) }
doubledArray.forEach { print($0)} // output is 4,8,12

print("\n2.2 ARRAY OF INTS PRINTED WITH MAP:")
let functionDefinedInClosureDoubledArray = arrayOfInts.map { $0 * 2 }
functionDefinedInClosureDoubledArray.forEach { print($0) } // output is 4,8,12

/// MARK: - Address
struct Address {
    let city: String
    let street: String
}

extension Address {
    init?(json: [String: Any]?) {
        guard let json = json,
            let city = json["city"] as? String,
            let street = json["street"] as? String else
        {
            return nil
        }

        self.city = city
        self.street = street
    }
}

extension Address: CustomStringConvertible {
    var description: String {
        return "\(city), \(street)"
    }
}

/// MARK: - Friend
struct Friend {
    let firstname: String
    let lastname: String
    let phonenumber: String
    let address: Address?
}

extension Friend {
    init?(json: [String: Any]?) {
        guard let json = json,
            let firstname = json["firstname"] as? String,
            let lastname = json["lastname"] as? String,
            let phonenumber = json["phonenumber"] as? String else
        {
            return nil
        }

        self.firstname = firstname
        self.lastname = lastname
        self.phonenumber = phonenumber
        self.address = Address(json: json["address"] as? [String: Any])
    }
}

extension Friend: CustomStringConvertible {
    var description: String {
        return "\(firstname), \(lastname), \(phonenumber)"//", \(address)"
    }
}

/// MARK: - map & flatMap with objects
let myFriendsJSONArray: [[String: Any]] = [
    ["firstname": "Jimmy",
     "lastname": "Swifty",
     "phonenumber": "1234567",
     "address": [
        "city": "Tampere",
         "street": "Hämeenkatu"
        ]
    ],
    ["firstname": "Timmy",
     "lastname": "Swifty",
     "phonenumber": "7654321",
     "address": []
    ]
]

// MARK: - 3. Examples, map with objects
print("\n3.0 ARRAY OF FRIENDS CREATED FROM JSON ARRAY WITH FOR-LOOP:")
var myFriends = [Friend]()
for friendJSON in myFriendsJSONArray {
    if let friend = Friend(json: friendJSON) {
        myFriends.append(friend)
    }
}

if let firstFriend = myFriends.first {
    print(firstFriend)
}

print("\n3.1 ARRAY OF FRIENDS CREATED FROM JSON ARRAY WITH MAP:")
let myFriends2 = myFriendsJSONArray.map { Friend(json: $0) }
myFriends2.forEach { print($0) }

// MARK: - 4. Examples flatMap with objects
print("\n4.0 OPTIONAL FLATMAP EXAMPLE")
let nestedOptional = Optional(Optional(10))
print(nestedOptional)
print(nestedOptional.myFlatMap { $0 })

print("\n4.1 OPTIONALS IN AN ARRAY FLATMAP EXAMPLE")
let optionalArray = [Optional(10), Optional(20), Optional(30)]
let array = optionalArray.myFlatMap({ $0 })
array.map { print($0) }

print("\n4.2 ADDRESSES CREATED USING MAP:")
let mappedAddresses = myFriendsJSONArray.map { Friend(json: $0)?.address }
mappedAddresses.forEach { print($0) }

print("\n4.3 ADDRESSES CREATED USING FLATMAP:")
let flatMappedAddresses = myFriendsJSONArray.myFlatMap { Friend(json: $0)?.address }
flatMappedAddresses.map { print($0) }

/// MARK: - Optional extension: map, flat and flatMap
extension Optional {
    func myMap<U>(_ f:(Wrapped) -> U) -> U? {
        switch self {
        case .some(let value):
            return .some(f(value))
        case .none:
            return .none
        }
    }

    func myFlatMap<U>(_ transform: (Wrapped) -> U?) -> U? {
        switch self {
        case .some(let value):
            return transform(value)
        case .none:
            return .none
        }
    }
}

/// MARK: - Array extension: flatMap
extension Array {
    func myFlatMap<T>(_ transform: (Element) -> T?) -> [T] {
        return map(transform).filter { $0 != nil }.map { $0! }
    }
}

