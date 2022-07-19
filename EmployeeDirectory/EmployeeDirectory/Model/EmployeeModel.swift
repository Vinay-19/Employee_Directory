//
//  EmployeeModel.swift
//  EmployeeDirectory
//
//  Created by Dev on 2022-07-12.
//

import Foundation

struct EmployeeModel {
    
    public enum EmployeeType: String {
        case fullTime = "FULL_TIME"
        case contractor = "CONTRACTOR"
        case partTime = "PART_TIME"
        
        func toString() -> String {
            switch self {
            case .fullTime:
                return "Full-Time"
            case .contractor:
                return "Contractor"
            case .partTime:
                return "Part-Time"
            }
        }
    }
    
    public var id: String
    public var fullName: String
    public var phoneNumber: String?
    public var emailAddress: String
    public var biography: String?
    public var smallPhotoURL: String?
    public var largePhotoURL: String?
    public var team: String
    public var employeeType: EmployeeType?
    
    public init(_ id: String, _ fullName: String, emailAddress: String, team: String) {
            self.id = id
            self.fullName = fullName
            self.emailAddress = emailAddress
            self.team = team
    }
    
    public init(_ id: String, _ fullName: String, _ phoneNumber: String, _ emailAddress: String, _ biography: String, _ smallPhotoURL: String, _ largePhotoURL: String, _ team: String, _ employeeType: EmployeeType?) {
        self.id = id
        self.fullName = fullName
        self.phoneNumber = phoneNumber
        self.emailAddress = emailAddress
        self.biography = biography
        self.smallPhotoURL = smallPhotoURL
        self.largePhotoURL = largePhotoURL
        self.team = team
        self.employeeType = employeeType
        
    }
    
    public init(json:[String: Any]){
        
        self.id = ""
        self.fullName = ""
        self.emailAddress = ""
        self.team = ""
        
        guard let id = json["uuid"] as? String else {
            return
        }
        
        guard let fullName = json["full_name"] as? String else {
            return
        }
        
        guard let emailAddress = json["email_address"] as? String else {
            return
        }
        
        guard let team = json["team"] as? String else {
            return
        }
        
        self.id = id
        self.fullName = fullName
        self.emailAddress = emailAddress
        self.team = team
        
        if let phoneNumber = json["phone_number"] as? String {
            self.phoneNumber = phoneNumber
        }
        
        if let biography = json["biography"] as? String {
            self.biography = biography
        }
        
        if let smallPhotoURL = json["photo_url_small"] as? String {
            self.smallPhotoURL = smallPhotoURL
        }
        
        if let largePhotoURL = json["photo_url_large"] as? String {
            self.largePhotoURL = largePhotoURL
        }
        
        if let employeeType = json["employee_type"] as? String {
            if employeeType == EmployeeType.fullTime.rawValue {
                self.employeeType = EmployeeType.fullTime
            } else if employeeType == EmployeeType.contractor.rawValue {
                self.employeeType = EmployeeType.contractor
            } else if employeeType == EmployeeType.partTime.rawValue {
                self.employeeType = EmployeeType.partTime
            }
        }
        
    }
    
}
