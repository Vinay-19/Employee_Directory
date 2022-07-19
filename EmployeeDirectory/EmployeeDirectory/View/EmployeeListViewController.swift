//
//  EmployeeListViewController.swift
//  EmployeeDirectory
//
//  Created by Dev on 2022-07-12.
//

import UIKit

class EmployeeListViewController: UIViewController {
    
    
    private static let tableViewRowHeight: CGFloat = 180
    private static let employeeSummaryTableViewCell = "EmployeeSummaryTableViewCell"
    
    @IBOutlet weak var tableView: UITableView!
    
    public var employeesGroupByTeamDictionary: [String: [EmployeeModel]]?
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getEmpData()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(getEmpData), for: .valueChanged)
        tableView.register(UINib(nibName: EmployeeListViewController.employeeSummaryTableViewCell, bundle: nil), forCellReuseIdentifier: EmployeeListViewController.employeeSummaryTableViewCell)        
    }
    
    
   @objc func getEmpData(){
        HTTPClient.shared.getEmployeeData { success, data in
            DispatchQueue.main.async {
                if success {
                    if let data = data, !data.isEmpty {
                        self.employeesGroupByTeamDictionary = data
                        self.tableView.reloadData()
                        self.refreshControl.endRefreshing()
                    } else {
                        self.setupEmptyState()
                        self.refreshControl.endRefreshing()
                        print("Empty State")
                    }
                }else{
                    print("no response")
                    self.setupError()
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    func setupEmptyState() {
        let alertController = UIAlertController(title: "", message: "No employee found in the directory.", preferredStyle: .alert)
        let mainAction = UIAlertAction(title: "Try Again", style: .default, handler: { [weak self] (alert) in
            self?.getEmpData()
        })
        
        alertController.addAction(mainAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func setupError() {
        let alertController = UIAlertController(title: "Error", message: "Oops! Something went wrong. Please try again later.", preferredStyle: .alert)
        let mainAction = UIAlertAction(title: "Try Again", style: .default, handler: { [weak self] (alert) in
            self?.getEmpData()
        })
        
        alertController.addAction(mainAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func formattingPhoneNumber(_ phoneNumber: String?) -> String? {
        
        if let phoneNumber = phoneNumber, phoneNumber.count == 10 {
            return phoneNumber.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "($1) $2-$3", options: .regularExpression, range: nil)
        }
        return nil
    }
    
    
    func getEmployeeListBySection(_ section: Int) -> [EmployeeModel] {
        
        guard let employeeDictionary = employeesGroupByTeamDictionary else {
            return []
        }
        
        for (index,dictionary) in employeeDictionary.enumerated() {
            if index == section {
                return dictionary.value
            }
        }
        
        return []
    }
    
}


// MARK: UITableViewDelegate
extension EmployeeListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return EmployeeListViewController.tableViewRowHeight
    }
}

//MARK: UITableViewDataSource 
extension EmployeeListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getEmployeeListBySection(section).count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.employeesGroupByTeamDictionary?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: EmployeeListViewController.employeeSummaryTableViewCell) as? EmployeeSummaryTableViewCell {
            let employees = getEmployeeListBySection(indexPath.section)
            let employee = employees[indexPath.item]
            cell.update(employee.fullName, employee.emailAddress, employee.employeeType?.toString(), formattingPhoneNumber(employee.phoneNumber), employee.largePhotoURL, employee.smallPhotoURL, employee.team)
            return cell
        }
        return UITableViewCell()
    }
}

