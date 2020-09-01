//
//  FilterViewController.swift
//  BoardgameApp
//
//  Created by casandra grullon on 4/28/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit

protocol FiltersAdded {
    func didAddFilters(ageFilter: [String], numberOfPlayersFilter: [String], priceFilter: [String], playtimeFilter: [String], filterSet: Bool, vc: FilterViewController)
}

class FilterViewController: UIViewController {
    
    //age buttons
    @IBOutlet weak var allAgesButton: UIButton!
    @IBOutlet weak var childrenButton: UIButton!
    @IBOutlet weak var teensButton: UIButton!
    @IBOutlet weak var adultsButton: UIButton!
    //number of players buttons
    @IBOutlet weak var twoFourButton: UIButton!
    @IBOutlet weak var fourSixButton: UIButton!
    @IBOutlet weak var sixPlusButton: UIButton!
    //price buttons
    @IBOutlet weak var cheapButton: UIButton!
    @IBOutlet weak var middleButton: UIButton!
    @IBOutlet weak var expensiveButton: UIButton!
    //average playtime stack
    @IBOutlet weak var thirtyLessButton: UIButton!
    @IBOutlet weak var thirtySixtyButton: UIButton!
    @IBOutlet weak var sixtyNinetyButton: UIButton!
    @IBOutlet weak var ninetyPlusButton: UIButton!
    
    @IBOutlet weak var clearButton: UIButton!
    
    public var delegate: FiltersAdded?
    public var ageFilter = [String]()
    public var numberOfPlayersFilter = [String]()
    public var priceFilter = [String]()
    public var genreFilter = [String]()
    public var playtimeFilter = [String]()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        clearButton.isEnabled = false
        clearButton.layer.cornerRadius = 13
    }
    private func configureNavBar() {
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0, green: 0.805752337, blue: 1, alpha: 1)
        navigationItem.title = "Filters"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .plain, target: self, action: #selector(addFiltersButtonPressed(_:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(dismissButtonPressed(_:)))
    }
    
    @IBAction func AgeButtonPressed(_ sender: UIButton) {
        clearButton.isEnabled = true
        if sender == allAgesButton {
            configureButton(button: allAgesButton, backgroundColor: #colorLiteral(red: 0, green: 0.641186893, blue: 1, alpha: 1), tintColor: .systemBackground)
        } else if sender == childrenButton {
            ageFilter.append("5")
            configureButton(button: childrenButton, backgroundColor: #colorLiteral(red: 0, green: 0.641186893, blue: 1, alpha: 1), tintColor: .systemBackground)
        } else if sender == teensButton {
            ageFilter.append("12")
            configureButton(button: teensButton, backgroundColor: #colorLiteral(red: 0, green: 0.641186893, blue: 1, alpha: 1), tintColor: .systemBackground)
        } else if sender == adultsButton {
            ageFilter.append("17")
            configureButton(button: adultsButton, backgroundColor: #colorLiteral(red: 0, green: 0.641186893, blue: 1, alpha: 1), tintColor: .systemBackground)
        }
    }
    
    @IBAction func numberPlayersButtonPressed(_ sender: UIButton) {
        clearButton.isEnabled = true
        if sender == twoFourButton {
            numberOfPlayersFilter.append("4")
            configureButton(button: twoFourButton, backgroundColor: #colorLiteral(red: 0, green: 0.641186893, blue: 1, alpha: 1), tintColor: .systemBackground)
        } else if sender == fourSixButton {
            numberOfPlayersFilter.append("6")
            configureButton(button: fourSixButton, backgroundColor: #colorLiteral(red: 0, green: 0.641186893, blue: 1, alpha: 1), tintColor: .systemBackground)
        } else if sender == sixPlusButton {
            numberOfPlayersFilter.append("10")
            configureButton(button: sixPlusButton, backgroundColor: #colorLiteral(red: 0, green: 0.641186893, blue: 1, alpha: 1), tintColor: .systemBackground)
        }
    }
    @IBAction func priceButtonPressed(_ sender: UIButton) {
        clearButton.isEnabled = true
        if sender == cheapButton {
            priceFilter.append("10")
            configureButton(button: cheapButton, backgroundColor: #colorLiteral(red: 0, green: 0.641186893, blue: 1, alpha: 1), tintColor: .systemBackground)
        } else if sender == middleButton {
            priceFilter.append("30")
            configureButton(button: middleButton, backgroundColor: #colorLiteral(red: 0, green: 0.641186893, blue: 1, alpha: 1), tintColor: .systemBackground)
        } else if sender == expensiveButton {
            priceFilter.append("50")
            configureButton(button: expensiveButton, backgroundColor: #colorLiteral(red: 0, green: 0.641186893, blue: 1, alpha: 1), tintColor: .systemBackground)
        }
    }
    @IBAction func playTimeButtonPressed(_ sender: UIButton) {
        clearButton.isEnabled = true
        switch sender {
        case thirtyLessButton:
            playtimeFilter.append("30")
            configureButton(button: thirtyLessButton, backgroundColor: #colorLiteral(red: 0, green: 0.641186893, blue: 1, alpha: 1), tintColor: .systemBackground)
        case thirtySixtyButton:
            playtimeFilter.append("60")
            configureButton(button: thirtySixtyButton, backgroundColor: #colorLiteral(red: 0, green: 0.641186893, blue: 1, alpha: 1), tintColor: .systemBackground)
        case sixtyNinetyButton:
            playtimeFilter.append("90")
            configureButton(button: sixtyNinetyButton, backgroundColor: #colorLiteral(red: 0, green: 0.641186893, blue: 1, alpha: 1), tintColor: .systemBackground)
        case ninetyPlusButton:
            playtimeFilter.append("150")
            configureButton(button: ninetyPlusButton, backgroundColor: #colorLiteral(red: 0, green: 0.641186893, blue: 1, alpha: 1), tintColor: .systemBackground)
        default:
            print("default")
        }
    }
    
    @objc private func addFiltersButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.didAddFilters(ageFilter: ageFilter, numberOfPlayersFilter: numberOfPlayersFilter, priceFilter: priceFilter, playtimeFilter: playtimeFilter, filterSet: true, vc: self)
        dismiss(animated: true)
    }
    @objc private func dismissButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction private func clearButtonPressed(_ sender: UIButton) {
        priceFilter.removeAll()
        ageFilter.removeAll()
        numberOfPlayersFilter.removeAll()
        genreFilter.removeAll()
        playtimeFilter.removeAll()
        
        let buttons = [expensiveButton, middleButton, cheapButton, twoFourButton, fourSixButton, sixPlusButton, allAgesButton, childrenButton, teensButton, adultsButton, thirtyLessButton, thirtySixtyButton, sixtyNinetyButton, ninetyPlusButton]
        for button in buttons {
            configureButton(button: button, backgroundColor: .systemBackground, tintColor: .systemGray)
        }
        clearButton.isEnabled = false
    }
    private func configureButton(button: UIButton?, backgroundColor: UIColor, tintColor: UIColor) {
        button?.backgroundColor = backgroundColor
        button?.tintColor = tintColor
    }
}
