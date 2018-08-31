//
//  ViewController.swift
//  CryptoWorkshop
//
//  Created by Matias Seijas on 8/31/18.
//  Copyright © 2018 TanookiLabs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var assetCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 0...5 {
            let imageView = ImageURLView(imageUrl: URL(string: "https://storage.googleapis.com/opensea-prod.appspot.com/0x06012c8cf97bead5deae237070f9587f8e7a266d/899656.svg")!)
            stackView.addArrangedSubview(imageView)
        }
    }

}
