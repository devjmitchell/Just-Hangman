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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem = backButton
        
        setupButtonBorders()
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
}
