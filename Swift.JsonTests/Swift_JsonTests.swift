//
//  Swift_JsonTests.swift
//  Swift.JsonTests
//
//  Created by Anderson Lucas C. Ramos on 13/03/17.
//
//

import XCTest
@testable import SwiftJson

class Swift_JsonTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

	func testJsonParser() {
		let jsonString = try! String(contentsOfFile: Bundle(for: self.classForCoder).path(forResource: "jsonObject", ofType: "json")!)
		
		let config = JsonConfig()
		config.set(forDataType: "Date") { (value, key) -> AnyObject? in
			if key == "date" {
				let formatter = DateFormatter()
				formatter.dateFormat = "dd/MM/yyyy"
				return formatter.date(from: value as! String) as AnyObject
			}
			return nil
		}
		
		let testObject: TestObject? = JsonParser.parse(string: jsonString, withConfig: config)
		assert(testObject != nil)
		assert(testObject?.name == "Anderson")
		assert(testObject?.age == 25)
		assert(testObject?.height == 1.85)
		assert(testObject?.employee?.name == "Jorge Xavier")
		assert(testObject?.employee?.age == 20)
		assert(testObject?.boss?.name == "Thiago N.")
		assert(testObject?.boss?.age == 55)
		assert(testObject?.boss?.bad == true)
	}
	
	func testJsonWriter() {
		let testObject = TestObject()
		testObject.name = "Anderson"
		testObject.age = 27
		testObject.employee = Employee()
		testObject.employee?.name = "Lucas"
		testObject.employee?.age = 35
		
		let jsonString = JsonWriter.write(anyObject: testObject)
		
		let jsonObject = try! JSONSerialization.jsonObject(with: jsonString!.data(using: .utf8)!, options: .allowFragments) as! [String: AnyObject]
		
		assert(testObject.name == jsonObject["name"] as? String)
		assert(testObject.age == jsonObject["age"] as? Int)
		
		let employee = jsonObject["employee"] as! [String: AnyObject]
		assert(testObject.employee?.name == employee["name"] as? String)
		assert(testObject.employee?.age == employee["age"] as? Int)
	}
	
	func testArrayWriting() {
		let emp1 = Employee()
		emp1.name = "Emp 1"
		emp1.age = 55
		let emp2 = Employee()
		emp2.name = "Emp 2"
		emp2.age = 35
		
		let testObject = TestObject()
		testObject.name = "Anderson"
		testObject.age = 27
		testObject.employee = Employee()
		testObject.employee?.name = "Lucas"
		testObject.employee?.age = 35
		testObject.boss = Boss()
		testObject.boss?.bad = false
		testObject.boss?.employees = Array()
		testObject.boss?.employees?.append(emp1)
		testObject.boss?.employees?.append(emp2)
		
		let jsonString = JsonWriter.write(anyObject: testObject)
		
		let jsonObject = try! JSONSerialization.jsonObject(with: jsonString!.data(using: .utf8)!, options: .allowFragments) as! [String: AnyObject]
		
		assert(testObject.name == jsonObject["name"] as? String)
		assert(testObject.age == jsonObject["age"] as? Int)
		
		let employee = jsonObject["employee"] as! [String: AnyObject]
		assert(testObject.employee?.name == employee["name"] as? String)
		assert(testObject.employee?.age == employee["age"] as? Int)
		
		let boss = jsonObject["boss"] as! [String: AnyObject]
		let employees = boss["employees"] as! [[String: AnyObject]]
		assert(testObject.boss?.employees?[0].name == employees[0]["name"] as? String)
		assert(testObject.boss?.employees?[0].age == employees[0]["age"] as? Int)
		
		assert(testObject.boss?.employees?[1].name == employees[1]["name"] as? String)
		assert(testObject.boss?.employees?[1].age == employees[1]["age"] as? Int)
	}
}

class Employee: NSObject {
	fileprivate(set) dynamic var name: String = ""
	fileprivate(set) dynamic var age: Int = 0
	
	required override init() {
		super.init()
	}
}

class Boss : Employee {
	fileprivate(set) dynamic var bad: Bool = false
	fileprivate(set) dynamic var employees: [Employee]?
	
	required init() {
		super.init()
	}
}

class TestObject : NSObject {
	fileprivate(set) dynamic var name: String?
	fileprivate(set) dynamic var age: Int = 0
	fileprivate(set) dynamic var height: Float = 0
	fileprivate(set) dynamic var employee: Employee?
	fileprivate(set) dynamic var boss: Boss?
	
	required override init() {
		super.init()
	}
}
