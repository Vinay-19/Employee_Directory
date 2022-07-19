//
//  HTTPClient.swift
//  EmployeeDirectory
//
//  Created by Dev on 2022-07-12.
//

import Foundation


class HTTPClient {
    
//     let endpoint = "https://s3.amazonaws.com/sq-mobile-interview/employees.json"
//
//     let emptyListEndpoint = "https://s3.amazonaws.com/sq-mobile-interview/employees_empty.json"
//
//     let malformedEndpoint = "https://s3.amazonaws.com/sq-mobile-interview/employees_malformed.json"
    
    
    static let endPoint = "https://run.mocky.io/v3/000c0dda-bbaf-4d52-9e1a-58d3a11e912b"
    
    static let delayEndpoint = "https://run.mocky.io/v3/000c0dda-bbaf-4d52-9e1a-58d3a11e912b?mocky-delay=4000ms"
    
    static let malformedEndpoint = "https://run.mocky.io/v3/000c0dda-bbaf-4d52-9e1a-58d3a11e912b?callback=myfunction"
    
    static let emptyListEndpoint = "https://s3.amazonaws.com/sq-mobile-interview/employees_empty.json"
    
    public var employees: [EmployeeModel]?
    
    static let shared = HTTPClient()
    
    func getEmployeeData(completion: @escaping (Bool,[String: [EmployeeModel]]?) -> ()) {
        
        let urlString = HTTPClient.endPoint
//        let urlString = HTTPClient.delayEndpoint
//        let urlString = HTTPClient.malformedEndpoint
//        let urlString = HTTPClient.emptyListEndpoint
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if error != nil {
                print(error!.localizedDescription)
                completion(false, nil)
                return
            }
            
            guard let data = data else {
                completion(false, nil)
                return
            }
            
            do {
                
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    if let jsonEmployees = json["employees"] as? NSArray {
                        
                        self.employees = []
                        for employee in jsonEmployees {
                            if let currentEmployee = employee as? [String: Any] {
                                let newEmployee = EmployeeModel(json: currentEmployee)
                                
                                if newEmployee.id.isEmpty {
                                    completion(false, nil)
                                    return
                                }
                                
                                self.employees?.append(newEmployee)
                            }
                        }

                        completion(true, self.buildEmployeeDictionaryGroupByTeam(self.employees ?? []))
                        
                    }
                }
                
                
            }catch{
                print("error casting json")
                completion(false, nil)
                return
            }
            
        }.resume()
        
        
    }
    
    
    func buildEmployeeDictionaryGroupByTeam(_ employeeList: [EmployeeModel]) -> [String: [EmployeeModel]]? {
        var result = [String: [EmployeeModel]]()
        for employee in employeeList.sorted(by: {$0.fullName < $1.fullName}) {
            if result[employee.team] == nil {
                result[employee.team] = [EmployeeModel]()
            }
            result[employee.team]?.append(employee)
        }
        return result
    }
    
}
