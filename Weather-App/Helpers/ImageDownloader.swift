//
//  ImageDownloader.swift
//  Mphasis-Weather-App
//
//  Created by Mark Alford on 5/16/23.
//

import Foundation
import UIKit

// extension used to help download images from ULRs
extension UIImageView {
    
    /**
     child func to be called by `downloadImg`func,  to download images form URL String. this will handle the data being parsed, and load it
     into the ImageView that is calling the `downloadImg` func
     - Parameters:
        - icon: String from the weather JSON needed to fill up the harcoded url String
        - mode: ContentMode of image being downloaded
     */
    func download(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    
    /**
     Main entry func used to download images form URL String. this is will call the func above to work on getting back an image.
     - Parameters:
        - icon: String from the weather JSON needed to fill up the harcoded url String
        - mode: ContentMode of image being downloaded
     */
    func downloadImg(from icon: String, contentMode mode: ContentMode = .scaleAspectFit) {
        let baseURL = "https://openweathermap.org/img/wn/\(icon)@2x.png"
        guard let url = URL(string: baseURL) else { return }
        download(from: url, contentMode: mode)
    }
}
