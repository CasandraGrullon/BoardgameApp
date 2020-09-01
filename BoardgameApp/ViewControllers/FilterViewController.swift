//
//  FilterViewController.swift
//  BoardgameApp
//
//  Created by casandra grullon on 4/28/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit

protocol FiltersAdded {
    func didAddFilters(filters: [String], ageFilter: [String], numberOfPlayersFilter: [String], priceFilter: [String], genreFilter: [String], playtimeFilter: [String], vc: FilterViewController)
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
    public var filters = [String]()
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
            filters.append("children")
            ageFilter.append("5")
            configureButton(button: childrenButton, backgroundColor: #colorLiteral(red: 0, green: 0.641186893, blue: 1, alpha: 1), tintColor: .systemBackground)
        } else if sender == teensButton {
            filters.append("teen")
            ageFilter.append("12")
            configureButton(button: teensButton, backgroundColor: #colorLiteral(red: 0, green: 0.641186893, blue: 1, alpha: 1), tintColor: .systemBackground)
        } else if sender == adultsButton {
            filters.append("adults")
            ageFilter.append("17")
            configureButton(button: adultsButton, backgroundColor: #colorLiteral(red: 0, green: 0.641186893, blue: 1, alpha: 1), tintColor: .systemBackground)
        }
    }
    
    @IBAction func numberPlayersButtonPressed(_ sender: UIButton) {
        clearButton.isEnabled = true
        if sender == twoFourButton {
            filters.append("2 - 4 players")
            numberOfPlayersFilter.append("4")
            configureButton(button: twoFourButton, backgroundColor: #colorLiteral(red: 0, green: 0.641186893, blue: 1, alpha: 1), tintColor: .systemBackground)
        } else if sender == fourSixButton {
            filters.append("4 - 6 players")
            numberOfPlayersFilter.append("6")
            configureButton(button: fourSixButton, backgroundColor: #colorLiteral(red: 0, green: 0.641186893, blue: 1, alpha: 1), tintColor: .systemBackground)
        } else if sender == sixPlusButton {
            filters.append("6 + players")
            numberOfPlayersFilter.append("10")
            configureButton(button: sixPlusButton, backgroundColor: #colorLiteral(red: 0, green: 0.641186893, blue: 1, alpha: 1), tintColor: .systemBackground)
        }
    }
    @IBAction func priceButtonPressed(_ sender: UIButton) {
        clearButton.isEnabled = true
        if sender == cheapButton {
            filters.append("$")
            priceFilter.append("10")
            configureButton(button: cheapButton, backgroundColor: #colorLiteral(red: 0, green: 0.641186893, blue: 1, alpha: 1), tintColor: .systemBackground)
        } else if sender == middleButton {
            filters.append("$$")
            priceFilter.append("30")
            configureButton(button: middleButton, backgroundColor: #colorLiteral(red: 0, green: 0.641186893, blue: 1, alpha: 1), tintColor: .systemBackground)
        } else if sender == expensiveButton {
            filters.append("$$$")
            priceFilter.append("50")
            configureButton(button: expensiveButton, backgroundColor: #colorLiteral(red: 0, green: 0.641186893, blue: 1, alpha: 1), tintColor: .systemBackground)
        }
    }
    @IBAction func playTimeButtonPressed(_ sender: UIButton) {
        clearButton.isEnabled = true
        switch sender {
        case thirtyLessButton:
            filters.append("< 30")
            playtimeFilter.append("< 30")
            configureButton(button: thirtyLessButton, backgroundColor: #colorLiteral(red: 0, green: 0.641186893, blue: 1, alpha: 1), tintColor: .systemBackground)
        case thirtySixtyButton:
            filters.append("30 - 60")
            playtimeFilter.append("30 - 60")
            configureButton(button: thirtySixtyButton, backgroundColor: #colorLiteral(red: 0, green: 0.641186893, blue: 1, alpha: 1), tintColor: .systemBackground)
        case sixtyNinetyButton:
            filters.append("60 - 90")
            playtimeFilter.append("60 - 90")
            configureButton(button: sixtyNinetyButton, backgroundColor: #colorLiteral(red: 0, green: 0.641186893, blue: 1, alpha: 1), tintColor: .systemBackground)
        case ninetyPlusButton:
            filters.append("90 +")
            playtimeFilter.append("90 +")
            configureButton(button: ninetyPlusButton, backgroundColor: #colorLiteral(red: 0, green: 0.641186893, blue: 1, alpha: 1), tintColor: .systemBackground)
        default:
            print("default")
        }
    }
    
    @objc private func addFiltersButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.didAddFilters(filters: filters, ageFilter: ageFilter, numberOfPlayersFilter: numberOfPlayersFilter, priceFilter: priceFilter, genreFilter: genreFilter, playtimeFilter: playtimeFilter, vc: self)
        dismiss(animated: true)
    }
    @objc private func dismissButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction private func clearButtonPressed(_ sender: UIButton) {
        filters.removeAll()
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
