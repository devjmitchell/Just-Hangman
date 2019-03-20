//
//  StartViewController.swift
//  Just Hangman
//
//  Created by Jason Mitchell on 3/20/19.
//  Copyright © 2019 Jason Mitchell. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    // TODO: Update contraints so buttons are stacked nicely
    // TODO: Add border around difficulty buttons so they look like letter buttons on next screen?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem = backButton
    }
    

    @IBAction func startGame(_ sender: UIButton) {
        guard let difficulty = sender.titleLabel?.text else { return }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        vc.difficulty = difficulty
        navigationController?.pushViewController(vc, animated: true)
    }
}
