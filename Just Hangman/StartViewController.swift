//
//  StartViewController.swift
//  Just Hangman
//
//  Created by Jason Mitchell on 3/20/19.
//  Copyright © 2019 Jason Mitchell. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    @IBOutlet var shortButton: UIButton!
    @IBOutlet var mediumButton: UIButton!
    @IBOutlet var longButton: UIButton!
    @IBOutlet var winStreakButton: UIButton!
    
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setChildBackButton()
        setupButtonBorders()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateWinStreakButton()
    }
    
    
    func setChildBackButton() {
        let backButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem = backButton
    }
    
    
    func updateWinStreakButton() {
        let winStreakShort = defaults.integer(forKey: "WinStreak-short")
        let winStreakMedium = defaults.integer(forKey: "WinStreak-medium")
        let winStreakLong = defaults.integer(forKey: "WinStreak-long")
        
        let winStreakArray = [winStreakShort, winStreakMedium, winStreakLong]
        guard let bestWinStreak = winStreakArray.max() else { return }
        winStreakButton.setTitle("Best Win Streak: \(String(describing: bestWinStreak))", for: .normal)
    }
    
    
    func setupButtonBorders() {
        let buttons: [UIButton] = [shortButton, mediumButton, longButton]
        
        for button in buttons {
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.darkGray.cgColor
        }
    }
    
    
    @IBAction func startGame(_ sender: UIButton) {
        guard let category = sender.titleLabel?.text else { return }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        vc.category = category
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func showWinStreaks(_ sender: UIButton) {
        let winStreakShort = defaults.integer(forKey: "WinStreak-short")
        let winStreakMedium = defaults.integer(forKey: "WinStreak-medium")
        let winStreakLong = defaults.integer(forKey: "WinStreak-long")
        
        let message = """
        Short Words: \(winStreakShort)
        Medium Words: \(winStreakMedium)
        Long Words: \(winStreakLong)
        """
        
        let ac = UIAlertController(title: "Best Win Streaks", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        ac.addAction(UIAlertAction(title: "Reset All", style: .destructive) { [weak self] _ in
            self?.defaults.set(0, forKey: "WinStreak-short")
            self?.defaults.set(0, forKey: "WinStreak-medium")
            self?.defaults.set(0, forKey: "WinStreak-long")
            self?.updateWinStreakButton()
        })
        present(ac, animated: true)
    }
}
