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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let tokenMetadataProvider = TokenMetadaProvider()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        let web3 = setupWeb3()
        
        // CryptoStrikers contract
        
        // Ethreum user account
        
        // Populate count label
        
        // Get Token metadata for each token
        
        // Render UI

        activityIndicator.stopAnimating()
    }
    
    // 1. Setup Ethereum node + web3 object
    func setupWeb3() -> web3 {
        
    }

    // 2. Setup contract with ABI
    func setupContract(with web3: web3, address: EthereumAddress) -> web3.web3contract {
        
    }
    
    // 3. Interact with the contract
    // 3a. Get token balance for an account
    func tokenBalance(for account: EthereumAddress, on contract: web3.web3contract) -> Int {
        
    }
    
    // 3b. Get token id by index
    func tokenId(for account: EthereumAddress, index: Int, on contract: web3.web3contract) -> Int {
        
    }
    
    // 3c. Get token metadata url by id
    func tokenMetadataURL(id: Int, on contract: web3.web3contract) -> URL {
        
    }
    
}
