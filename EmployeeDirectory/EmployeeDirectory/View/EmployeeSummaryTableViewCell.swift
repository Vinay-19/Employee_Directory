//
//  EmployeeSummaryTableViewCell.swift
//  EmployeeDirectory
//
//  Created by Dev on 2022-07-12.


import UIKit
import SDWebImage


class EmployeeSummaryTableViewCell: UITableViewCell {

    private static let photoCornerRadius: CGFloat = 50
    private static let viewCornerRadius: CGFloat = 8
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var employeePhotoImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var emailAddressLabel: UILabel!
    @IBOutlet weak var employeeTypeLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var employeeTeam: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.employeePhotoImageView.layer.cornerRadius = EmployeeSummaryTableViewCell.photoCornerRadius
        self.containerView.layer.cornerRadius = EmployeeSummaryTableViewCell.viewCornerRadius
    }
    
    func update(_ fullName: String?, _ emailAddress: String?, _ employeeType: String?, _ phoneNumber: String?, _ largePhotoURL: String?, _ smallPhotoURL: String?, _ team: String?) {
        self.fullNameLabel.text = fullName
        self.emailAddressLabel.text = emailAddress
        self.employeeTypeLabel.text = employeeType
        self.employeeTeam.text = team
        
        self.phoneNumberLabel.text = ""
        if let phoneNumber = phoneNumber {
            self.phoneNumberLabel.text = phoneNumber
        }
        if let photo = smallPhotoURL {
            employeePhotoImageView?.sd_setImage(with: URL(string: photo))
        }
    }

}
