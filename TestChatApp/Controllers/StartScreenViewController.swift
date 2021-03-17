//
//  ViewController.swift
//  TestChatApp
//
//  Created by Аня Воронцова on 15.03.2021.
//

import UIKit

class StartScreenViewController: UIViewController {

    @IBOutlet weak var startScreenOutlet: UIImageView!
    @IBOutlet weak var enterButtonOutlet: UIButton!
    
    
    override func viewDidLoad() {
        navigationController?.navigationBar.isHidden = true
        super.viewDidLoad()
        startScreenOutlet.dropshadow(color: UIColor.black, opacity: 0.5, radius: 4)
        enterButtonOutlet.dropshadow(color: UIColor(named: K.brandColors.redShadow)!, opacity: 0.5, radius: 9)
        enterButtonOutlet.layer.backgroundColor = UIColor(named: K.brandColors.redColor)!.cgColor
        enterButtonOutlet.layer.cornerRadius = enterButtonOutlet.frame.height / 2
        enterButtonOutlet.titleLabel?.text = "Enter"
        enterButtonOutlet.titleLabel?.tintColor = .white
        enterButtonOutlet.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }

    @IBAction func enterButtonPressed(_ sender: UIButton) {
    }
    
}

