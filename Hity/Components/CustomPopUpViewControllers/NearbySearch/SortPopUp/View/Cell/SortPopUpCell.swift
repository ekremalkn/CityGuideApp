//
//  SortPopUpCell.swift
//  Hity
//
//  Created by Ekrem Alkan on 24.02.2023.
//

import UIKit

final class SortPopUpCell: UITableViewCell {
    
    //MARK: - Cell's Identifier
    
    static let identifier = "SortPopUpCell"
    
    //MARK: - Init methods
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configure Cell
    
    private func configureCell() {
        selectionStyle = .none
        imageView?.tintColor = .blue
        textLabel?.textColor = .black
        detailTextLabel?.textColor = .systemGray
    }
    
    func changeText(_ text: String, _ detailText: String) {
        textLabel?.text = text
        detailTextLabel?.text = detailText
    }
    
    func toggleImageView(_ isSelected: Bool) {
        if isSelected {
            imageView?.image = UIImage(systemName: "checkmark")
        } else {
            imageView?.image = nil
        }
        
    }
    
    
}
