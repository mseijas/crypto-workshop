//
//  ImageURLView.swift
//  CryptoWorkshop
//
//  Created by Matias Seijas on 8/31/18.
//  Copyright © 2018 TanookiLabs. All rights reserved.
//

import UIKit

class ImageURLView: UIView {

    let imageUrl: URL
    let imageView: UIImageView
    let errorLabel: UILabel
    let activityIndicator: UIActivityIndicatorView
    
    private var task: URLSessionTask?
    
    // MARK: - Life Cycle
    
    init(imageUrl: URL, frame: CGRect = CGRect(x: 0, y: 0, width: 200, height: 200)) {
        self.imageUrl = imageUrl
        self.imageView = UIImageView(frame: .zero)
        self.errorLabel = UILabel(frame: .zero)
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        setupLayout()
        loadImage()
    }
    
    // MARK: - Configuration
    
    private func setupLayout() {
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        errorLabel.numberOfLines = 1
        errorLabel.font = UIFont.systemFont(ofSize: 10)
        errorLabel.textAlignment = .center
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(errorLabel)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)
        
        imageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        errorLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        errorLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: 10).isActive = true
        errorLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        setNeedsDisplay()
        layoutIfNeeded()
    }
    
    private func loadImage() {
        showSpinner()
        setError(message: "")
        
        let session = URLSession.shared
        let imageUrl = self.imageUrl.pathExtension == "svg" ? ZippySVG(imageUrl: self.imageUrl) : self.imageUrl
        
        task = session.dataTask(with: imageUrl, completionHandler: { [weak self] (data, response, error) in
            guard let `self` = self else { return }
            
            defer {
                self.hideSpinner()
            }
            
            if let error = error {
                self.setError(message: error.localizedDescription)
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                self.setError(message: "Server response: \(response.statusCode)")
                return
            }
            
            if let data = data,
                let image = UIImage(data: data) {
                self.setImage(image)
            } else {
                self.setError(message: "Unable to decode image")
            }
        })
        
        task?.resume()
    }
    
    // MARK: - UI Actions
    
    private func setError(message: String) {
        DispatchQueue.main.async {
            self.errorLabel.text = message
        }
    }
    
    private func setImage(_ image: UIImage) {
        DispatchQueue.main.async {
            self.imageView.image = image
        }
    }
    
    private func showSpinner() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.activityIndicator.isHidden = false
        }
    }
    
    private func hideSpinner() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
    
}

// MARK: - ZippySVG

fileprivate func ZippySVG(imageUrl: URL) -> URL {
    let baseURL = URL(string: "https://zippy-svg.herokuapp.com/svg")!
    var zippyURL = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)!
    zippyURL.queryItems = [URLQueryItem(name: "url", value: imageUrl.absoluteString)]
    return zippyURL.url!
}
