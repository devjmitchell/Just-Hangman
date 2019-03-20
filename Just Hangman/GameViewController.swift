//
//  GameViewController.swift
//  Just Hangman
//
//  Created by Jason Mitchell on 3/19/19.
//  Copyright © 2019 Jason Mitchell. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    @IBOutlet var hangmanImage: UIImageView!
    @IBOutlet var usedLettersLabel: UILabel!
    @IBOutlet var buttonsView: UIView!
    @IBOutlet var scoreLabel: UILabel!
    
    // TODO: Continue scrubbing word lists to make sure no words have spaces or special characters (also, do they belong in that difficulty)
    var difficulty = ""
    var allWords = [String]()
    var word = ""
    var wordIndex = 0
    var usedLetters = [String]()
    var promptWord = ""
    var letterButtons = [UIButton]()
    var score = 0 {
        didSet {
            scoreLabel.text = "Score = \(score)"
        }
    }
    var wrongGuessesRemaining = 7 {
        didSet {
            hangmanImage.image = UIImage(named: "hangman\(wrongGuessesRemaining)")
        }
    }
    
    
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        loadInitialWord()
        loadButtons()
    }
    
    
    
    // MARK: - Setup Methods
    
    func loadInitialWord() {
        let fileName = "words-\(difficulty.lowercased())"
        if let wordsURL = Bundle.main.url(forResource: fileName, withExtension: "txt") {
            if let wordsContents = try? String(contentsOf: wordsURL) {
                let words = wordsContents.components(separatedBy: "\n")
                allWords = words.filter { $0 != ""}
                allWords.shuffle()
                
                
//                // TODO: This will be used to have alphabetized word list that I can update words.txt with -- Remove after done!
//                let setOfWords = Set(allWords)
//                let sortedWords = setOfWords.sorted()
//                for word in sortedWords {
//                    print(word.lowercased())
//                }
                
                
                word = allWords[0].uppercased()
                updatePromptWord()
            }
        }
    }
    
    
    func loadButtons() {
        let width = buttonsView.frame.width / 6
        let height = buttonsView.frame.height / 5
        
        for row in 0..<5 {
            for column in 0..<6 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                
                let x = CGFloat(column) * width + 5
                let y = CGFloat(row) * height + 5
                let frame = CGRect(x: x, y: y, width: width - 10, height: height - 10)
                letterButton.frame = frame
                
                buttonsView.addSubview(letterButton)
                letterButtons.append(letterButton)
            }
        }
        
        for (index, letter) in "ABCDEFGHIJKLMNOPQRSTUVWXYZ".enumerated() {
            letterButtons[index].setTitle(String(letter), for: .normal)
            letterButtons[index].layer.cornerRadius = 5
            letterButtons[index].layer.borderWidth = 1
            letterButtons[index].layer.borderColor = UIColor.darkGray.cgColor
            letterButtons[index].tag = index
        }
    }
    
    
    
    // MARK: - Game methods
    
    func updatePromptWord() {
        promptWord = ""
        
        for letter in word {
            let strLetter = String(letter)
            
            if usedLetters.contains(strLetter) {
                promptWord.append(strLetter)
            } else {
                promptWord.append("_ ")
            }
        }
        
        title = promptWord.trimmingCharacters(in: .whitespaces)
        
        if !promptWord.contains("_") {
            score += 1
            
            let title = "You Win!"
            let message = "Great job guessing the correct word."
            presentGameOverAlert(title: title, message: message)
        }
    }
    
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let letter = sender.titleLabel?.text else { return }
        
        letterButtons[sender.tag].isHidden = true
        
        if !word.contains(letter) {
            wrongGuessesRemaining -= 1
            
            if wrongGuessesRemaining == 0 {
                let title = "Game Over"
                let message = "The correct word was \(word)"
                presentGameOverAlert(title: title, message: message)
            }
        }
        
        usedLetters.append(letter)
        updateUsedLetters()
        updatePromptWord()
    }
    
    
    func updateUsedLetters() {
        let labelLetters = usedLetters.joined(separator: " ")
        usedLettersLabel.text = "Used Letters:\n \(labelLetters)"
    }
    
    
    func presentGameOverAlert(title: String, message: String, actionTitle: String? = "Play Again") {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: actionTitle, style: .default, handler: startNewGame))
        present(ac, animated: true)
    }
    
    
    func startNewGame(action: UIAlertAction) {
        wordIndex += 1
        if allWords.count == wordIndex {
            let ac = UIAlertController(title: "No more words!", message: "You've answered them all!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Start Over", style: .default))
            present(ac, animated: true)
            
            wordIndex = 0
            allWords.shuffle()
        }
        word = allWords[wordIndex]
        wrongGuessesRemaining = 7
        usedLetters = []
        updateUsedLetters()
        updatePromptWord()
        resetButtons()
    }
    
    
    func resetButtons() {
        for button in letterButtons {
            button.isHidden = false
        }
    }
}

