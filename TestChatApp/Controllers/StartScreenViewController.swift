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
        enterButtonOutlet.alpha = 0
        
        UIView.animate(withDuration: 1.0) {
                self.enterButtonOutlet.alpha = 1.0
            }
        
        
        
        UIView.animate(withDuration: 0.2, delay: 1.0,
            animations: {
                self.enterButtonOutlet.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            },
            completion: { _ in
                UIView.animate(withDuration: 0.2) {
                    self.enterButtonOutlet.transform = CGAffineTransform.identity
                }
            })
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

