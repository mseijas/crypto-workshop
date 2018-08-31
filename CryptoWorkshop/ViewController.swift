//
//  ViewController.swift
//  CryptoWorkshop
//
//  Created by Matias Seijas on 8/31/18.
//  Copyright © 2018 TanookiLabs. All rights reserved.
//

import UIKit
import web3swift
import BigInt

class ViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var assetCountLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let tokenMetadataProvider = TokenMetadaProvider()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        let web3 = setupWeb3()
        
        // CryptoStrikers contract
        let contractAddress = EthereumAddress("0xdCAad9Fd9a74144d226DbF94ce6162ca9f09ED7e")!
        let cryptoStrickers = setupContract(with: web3, address: contractAddress)
        
        // Ethreum user account
        let account = EthereumAddress("0x07045DF5c829293a218877cA5A6879359eE2FB4b")!
        
        // Populate count label
        let assetCount = tokenBalance(for: account, on: cryptoStrickers)
        assetCountLabel.text = "Total: \(assetCount)"
        
        // Get Token metadata for each token
        var tokens = [TokenMetada]()
        for index in 0..<assetCount {
            let id = tokenId(for: account, index: index, on: cryptoStrickers)
            let metadataUrl = tokenMetadataURL(id: id, on: cryptoStrickers)
            let tokenMetadata = tokenMetadataProvider.getMetadata(with: metadataUrl)!
            tokens.append(tokenMetadata)
        }
        
        // Render UI
        for token in tokens {
            let imageUrl = URL(string: token.image)!
            let imageView = ImageURLView(imageUrl: imageUrl)
            stackView.addArrangedSubview(imageView)
        }
        activityIndicator.stopAnimating()
    }
    
    // 1. Setup Ethereum node + web3 object
    func setupWeb3() -> web3 {
        let infura = InfuraProvider(Networks.Mainnet, accessToken: "8f6ac56952364668a7cea09c2976a981")!
        let web3 = Web3.new(infura.url)!
        return web3
    }

    // 2. Setup contract with ABI
    func setupContract(with web3: web3, address: EthereumAddress) -> web3.web3contract {
        let abiJSON = Bundle.main.path(forResource: "ERC721", ofType: "json")!
        let abi = try! String(contentsOfFile: abiJSON, encoding: .utf8)
        
        let contract = web3.contract(abi,
                                     at: address,
                                     abiVersion: 2)!
        return contract
    }
    
    // 3. Interact with the contract
    // 3a. Get token balance for an account
    func tokenBalance(for account: EthereumAddress, on contract: web3.web3contract) -> Int {
        let parameters = [account.address] as [AnyObject]
        
        let result = contract.method("balanceOf",
                                     parameters: parameters,
                                     options: nil)!
                             .call(options: nil)
        
        switch result {
        case .success(let returnValues):
            let balance = returnValues["0"] as! BigUInt
            return Int(balance)
            
        case .failure(let error):
            fatalError(error.localizedDescription)
        }
    }
    
    // 3b. Get token id by index
    func tokenId(for account: EthereumAddress, index: Int, on contract: web3.web3contract) -> Int {
        let parameters = [account.address, index] as [AnyObject]
        
        let result = contract.method("tokenOfOwnerByIndex",
                                     parameters: parameters,
                                     options: nil)!
                             .call(options: nil)
        
        switch result {
        case .success(let returnValues):
            let tokenIndex = returnValues["0"] as! BigUInt
            return Int(tokenIndex)
            
        case .failure(let error):
            fatalError(error.localizedDescription)
        }
    }
    
    // 3c. Get token metadata url by id
    func tokenMetadataURL(id: Int, on contract: web3.web3contract) -> URL {
        let parameters = [id] as [AnyObject]
        
        let result = contract.method("tokenURI",
                                     parameters: parameters,
                                     options: nil)!
                             .call(options: nil)
        
        switch result {
        case .success(let returnValues):
            let uri = returnValues["0"] as! String
            return URL(string: uri)!
            
        case .failure(let error):
            fatalError(error.localizedDescription)
        }
    }
    
}
