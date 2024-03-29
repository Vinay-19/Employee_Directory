//
//  EmployeeDirectoryListViewController.swift
//  EmployeeDirectoryApp
//
//  Created by Mauricio Esteves on 2019-12-27.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit

/* EmployeeDirectoryListViewController is responsible to present employee data through an UITableView. */
class EmployeeDirectoryListViewController: Base {

    /* MARK: STATIC VARIABLES */
    private static let tableViewHeaderHeight: CGFloat = 30
    private static let tableViewRowHeight: CGFloat = 170
    private static let employeeSummaryTableViewCell = "EmployeeSummaryTableViewCell"
    
    @IBOutlet weak var tableView: UITableView!
    
    public var employeesGroupByTeamDictionary: [String: [EmployeeModel]]?
    
    /** The empty state label. */
    public lazy var emptyStateLabel: UILabel = {
        let label                                       = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font                                      = UIFont(name: "HelveticaNeue", size: 16)
        label.textColor = UIColor.darkGray
        label.numberOfLines = 0
        label.text = "Employee.EmptyState"
        label.textAlignment = .center
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        requestData()
        
        self.navigationController?.isNavigationBarHidden = true
        
        //stick the header to the tableView while scrolling
        let viewHeight = CGFloat(40)
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: viewHeight))
        self.tableView.contentInset = UIEdgeInsets(top: -viewHeight, left: 0, bottom: 0, right: 0)
        
        tableView.register(UINib(nibName: EmployeeDirectoryListViewController.employeeSummaryTableViewCell, bundle: nil), forCellReuseIdentifier: EmployeeDirectoryListViewController.employeeSummaryTableViewCell)
    }
    
    /**
     * Request Employee data.
     */
    func requestData() {
        displayActivityIndicator(true)

        let httpClient = HTTPClient()
        httpClient.getEmployeeData { [weak self] (success, data) -> Void in
            DispatchQueue.main.async {
                if success {
                    if let data = data, !data.isEmpty {
                        self?.employeesGroupByTeamDictionary = data
                        self?.tableView.reloadData()
                    } else {
                        self?.setupEmptyState()
                    }
                } else {
                    //error in the request (caused by malformed data)
                    self?.setupErrorState()
                }
                
                self?.displayActivityIndicator(false)
            }
        }
    }
    
    /* Setup empty state if there is no data to be presented. */
    func setupEmptyState() {
        self.view.addSubview(emptyStateLabel)
        self.emptyStateLabel.isHidden = false
        
        NSLayoutConstraint.activate([
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50),
            ])
    }
    
    /* Setup an error state if there is any connection problem. */
    func setupErrorState() {
        let alertController = UIAlertController(title: "Error", message: "Oops! Something went wrong. Please check your internet and try again later.", preferredStyle: .alert)
        let mainAction = UIAlertAction(title: "Try Again", style: .default, handler: { [weak self] (alert) in
            self?.requestData()
        })
        
        alertController.addAction(mainAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    /* Return the phone number formatted. */
    func formattingPhoneNumber(_ phoneNumber: String?) -> String? {
        
        if let phoneNumber = phoneNumber, phoneNumber.count == 10 {
            return phoneNumber.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "($1) $2-$3", options: .regularExpression, range: nil)
        }
        
        return nil
    }
    
    /** Return the employee list based on the given section. */
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

/* MARK: UITableViewDelegate */
extension EmployeeDirectoryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return EmployeeDirectoryListViewController.tableViewRowHeight
    }
}

/* MARK: UITableViewDataSource */
extension EmployeeDirectoryListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return the number of employees inside the dictionary based on the given section
        return getEmployeeListBySection(section).count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //the number of section is represented by the number of entries in the dictionary
        return self.employeesGroupByTeamDictionary?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: EmployeeDirectoryListViewController.employeeSummaryTableViewCell) as? EmployeeSummaryTableViewCell {
            
            //retrieve the employee given the section
            let employees = getEmployeeListBySection(indexPath.section)
            //retrieve the current employee from the employee list
            let employee = employees[indexPath.item]
            
            //cell.delegate = self
            cell.update(employee.fullName, employee.emailAddress, employee.employeeType?.toString(), formattingPhoneNumber(employee.phoneNumber), employee.largePhotoURL, employee.smallPhotoURL)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    /* Return the UITableView Header, grouped by Team. */
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = UIColor.black
        
        let teamLabel = UILabel(frame: CGRect(x: 15, y: 15, width:
            tableView.bounds.size.width, height: tableView.bounds.size.height))
        teamLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        teamLabel.textColor = UIColor.lightGray
        teamLabel.text = getEmployeeListBySection(section).first?.team
        teamLabel.sizeToFit()
        
        header.addSubview(teamLabel)
        
        return header
    }
    
    /* UITableView header height */
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return EmployeeDirectoryListViewController.tableViewHeaderHeight
    }
    
}

//extension EmployeeDirectoryListViewController: EmployeeSummaryTableViewCellDelegate {
//    
//    func didTouchEmployeePhoto(photo: UIImage) {
//        let controller = EmployeeDialogViewController()
//        controller.modalTransitionStyle = .flipHorizontal
//        self.navigationController?.present(controller, animated: true)
//        controller.photoImageView?.image = photo
//    }
//}
