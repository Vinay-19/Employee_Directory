//
//  EmployeeDirectoryTests.swift
//  EmployeeDirectoryTests
//
//  Created by Dev on 2022-07-12.
//

import XCTest
@testable import EmployeeDirectory

class EmployeeDirectoryTests: XCTestCase {

    
    //Given list of employees, system should group the employees by team.
    
    func testGivenListOf5EmployeesShouldGroupByTeam(){
        
        let employee1 = EmployeeModel("1", "Vinay", emailAddress: "vinay.thapa@gmail.com", team: "Restaurants")
        let employee2 = EmployeeModel("2", "Raj", emailAddress: "raj.rathod@gmail.com", team: "Cash")
        let employee3 = EmployeeModel("3", "Aditya", emailAddress: "aditya.singh@gmail.com", team: "Cash")
        let employee4 = EmployeeModel("4", "Shivu", emailAddress: "shivu@gmail.com", team: "Restaurants")
        let employee5 = EmployeeModel("5", "Aditya", emailAddress: "aditya.singh@gmail.com", team: "Hardware")
        
        
        let employees = [employee1,employee2,employee3,employee4,employee5]
        
        let groupedDictionary = HTTPClient.shared.buildEmployeeDictionaryGroupByTeam(employees)
        
        guard let result = groupedDictionary else {
            assertionFailure("result should not be nil")
            return
        }
        
        XCTAssertEqual(result.count,3) // Dictionary should contain 3 entries.
        XCTAssertEqual(result["Restaurants"]?.count,2) // Restaurants key should have 2 employees
        XCTAssertEqual(result["Cash"]?.count,2) // Cash key should have 2 employee
        XCTAssertEqual(result["Hardware"]?.count,1) // Hardware key should have 1 employee
        
        
        
        
    }
    
    // System should return the dictionary grouped by team and sorted by employee name.
    
    func testGivenListOfEmployeesGroupByTamAndSortByName() {
        let employee1 = EmployeeModel("1", "Vinay", emailAddress: "vinay.thapa@gmail.com", team: "Cash")
        let employee2 = EmployeeModel("2", "Raj", emailAddress: "raj.rathod@gmail.com", team: "Cash")
        let employee3 = EmployeeModel("3", "Aditya", emailAddress: "aditya.singh@gmail.com", team: "Cash")
        
        let employees = [employee1,employee2,employee3]
        
        let groupedSortedDictionary = HTTPClient.shared.buildEmployeeDictionaryGroupByTeam(employees)
        
        guard let result = groupedSortedDictionary else {
            assertionFailure("result should not be nil")
            return
        }
        
        
        let cashTeamEmployees = result["Cash"]
        
        XCTAssert(cashTeamEmployees?[0].fullName == "Aditya") // First name should be Aditya
        XCTAssert(cashTeamEmployees?[1].fullName == "Raj")    // Second name should be Raj
        XCTAssert(cashTeamEmployees?[2].fullName == "Vinay")  // Third name should be Vinay
    }
    
    // System should format the phone number
    
    func testGivenPhoneNumberShouldFormatThePhoneNumber(){

        let viewController = EmployeeListViewController()

        let phoneNumber = "5553280123"

        let formattedNumber = viewController.formattingPhoneNumber(phoneNumber)

        XCTAssert(formattedNumber == "(555) 328-0123")


    }
    
    
    
}
