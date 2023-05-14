//
//  WebsiteCellViewConfigurator.swift
//  SafariHighlighter
//
//  Created by Andrey Yakovlev on 14.05.2023.
//

import Persistence
import WebKit


final class WebsiteCellViewConfigurator {
    
    // MARK: - Internal
    
    func configure(website: Website, in cell: WebsiteTableViewCell) {
        
        var model = WebsiteTableViewCell.Model(
            uniqueId: website.uniqueId,
            logo: nil,
            title: website.name,
            subtitle: website.url.absoluteString,
            count: numberOfHighlightsString(for: website.numberOfHighlights)
        )
        
        cell.set(model: model)
        
        
        guard let faviconUrl = formFaviconUrl(from: website.url) else { return }
        
        loadImage(from: faviconUrl) { image in
            DispatchQueue.main.async {
                guard cell.uniqueId == model.uniqueId else { return }
                
                model.logo = image
                
                cell.set(model: model)
            }
        }
    }
    
    // MARK: - Private
    
    private func numberOfHighlightsString(for numberOfHighlights: Int?) -> String? {
        guard let numberOfHighlights, numberOfHighlights > 0 else { return nil }
        
        return "\(numberOfHighlights)"
    }
    
    private func formFaviconUrl(from url: URL) -> URL? {
        guard let scheme = url.scheme, let host = url.host else { return nil }
                
        var components = URLComponents()
        components.host = host
        components.scheme = scheme
        components.path = "/favicon.ico"
        
        return components.url
    }
    
    private func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(nil)
                return
            }
            let image = UIImage(data: data)
            completion(image)
        }
        task.resume()
    }
}
