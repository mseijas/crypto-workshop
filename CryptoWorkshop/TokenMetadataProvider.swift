//
//  TokenMetadataProvider.swift
//  CryptoWorkshop
//
//  Created by Matias Seijas on 8/31/18.
//  Copyright © 2018 TanookiLabs. All rights reserved.
//

import Foundation

class TokenMetadaProvider {
    
    func getMetadata(with url: URL) -> TokenMetada? {
        let session = URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
        
        var tokenMetadata: TokenMetada?
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                tokenMetadata = nil
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                print("Error: Server responded with \(response.statusCode)")
                tokenMetadata = nil
            }
            
            let decoder = JSONDecoder()
            if let data = data,
                let response = try? decoder.decode(TokenMetada.self, from: data) {
                tokenMetadata = response
            } else {
                print("Error: JSON parsing error")
                tokenMetadata = nil
            }
            
            semaphore.signal()
        }
        
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        
        return tokenMetadata
    }
    
}
