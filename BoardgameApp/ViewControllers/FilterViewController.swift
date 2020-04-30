//
//  FilterViewController.swift
//  BoardgameApp
//
//  Created by casandra grullon on 4/28/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {
    
    @IBOutlet weak var genreCollectionView: UICollectionView!
    @IBOutlet weak var ageSegment: UISegmentedControl!
    @IBOutlet weak var playersSegment: UISegmentedControl!
    @IBOutlet weak var priceSegement: UISegmentedControl!
    @IBOutlet weak var addFiltersButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func addFiltersButtonPressed(_ sender: UIButton) {
        
    }
}
