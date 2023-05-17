//
//  ImageDownloader.swift
//  Mphasis-Weather-App
//
//  Created by Mark Alford on 5/16/23.
//

import Foundation
import UIKit

extension UIImageView {
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
    
    func downloadImg(from icon: String, contentMode mode: ContentMode = .scaleAspectFit) {
        let baseURL = "https://openweathermap.org/img/wn/\(icon)@2x.png"
        guard let url = URL(string: baseURL) else { return }
        download(from: url, contentMode: mode)
    }
}
