//
//  ViewController.swift
//  Wordle
//
//  Created by Mari Batilando on 2/12/23.
//

import UIKit

class ViewController: UIViewController,
                      SettingsViewControllerDelegate {
  
  @IBOutlet weak var wordsCollectionView: UICollectionView!
  @IBOutlet weak var keyboardCollectionView: UICollectionView!
  
  private var boardController: BoardController!
  private var keyboardController: KeyboardController!
  
  private let segueIdentifier = "SettingsViewControllerSegue"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupNavigationBar()
    
    boardController = BoardController(collectionView: wordsCollectionView)
    keyboardController = KeyboardController(collectionView: keyboardCollectionView)
    keyboardController.didSelectString = { [unowned self] string in
      if string == kDeleteKey {
        self.boardController.deleteLastCharacter()
      } else {
        self.boardController.enter(string)
      }
    }
    
    // SETTINGS BUTTON (right side)
    let rightBarButtonItem = UIBarButtonItem(title: "Settings",
                                             style: .plain,
                                             target: self,
                                             action: #selector(didTapSettingsButton))
    rightBarButtonItem.tintColor = .white
    navigationItem.rightBarButtonItem = rightBarButtonItem
    
    // RESET BUTTON (left side) — Exercise 5 Pt. 1
    let leftBarButtonItem = UIBarButtonItem(title: "Reset",
                                            style: .plain,
                                            target: self,
                                            action: #selector(didTapResetButton))
    leftBarButtonItem.tintColor = .white
    navigationItem.leftBarButtonItem = leftBarButtonItem
  }
  
  @objc private func didTapSettingsButton() {
    performSegue(withIdentifier: segueIdentifier, sender: nil)
  }
  
  // RESET BUTTON ACTION
  @objc private func didTapResetButton() {
    boardController.resetBoardWithCurrentSettings()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard segue.identifier == segueIdentifier else { return }
    let settingsViewController = segue.destination as! SettingsViewController
    settingsViewController.delegate = self
  }
  
  func didChangeSettings(with settings: [String: Any]) {
    boardController.resetBoard(with: settings)
  }
}

