//
//  FilterCell.swift
//  BoardgameApp
//
//  Created by casandra grullon on 4/30/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit
protocol RemoveFilter: NSObject {
    func tappedRemoveButton(cell: FilterCell, filter: String)
}

class FilterCell: UICollectionViewCell {
    @IBOutlet weak var filterNameLabel: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    weak var delegate: RemoveFilter?
    
    public var filter: String?
    
    @IBAction func removeButtonPressed(_ sender: UIButton) {
        if let filter = filter {
            delegate?.tappedRemoveButton(cell: self, filter: filter)
        }
    }
}
