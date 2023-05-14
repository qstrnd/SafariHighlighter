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
    
    init(
        imageCacheService: ImageCacheServiceProtocol
    ) {
        self.imageCacheService = imageCacheService
    }
    
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
        
        imageCacheService.loadCachedImage(for: faviconUrl) { [weak self] cachedImage in
            guard let self = self else { return }
            
            if let image = cachedImage {
                model.logo = image
                self.update(cell: cell, model: model)
            } else {
                self.loadImage(from: faviconUrl) { downloadedImage in
                    guard let image = downloadedImage else { return }
                    
                    self.imageCacheService.save(image: image, for: faviconUrl)
                    
                    model.logo = image
                    self.update(cell: cell, model: model)
                }
            }
        }
        
    }
    
    // MARK: - Private
    
    private let imageCacheService: ImageCacheServiceProtocol
    
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
        // TODO: Add some logic to check for existing download tasks in case multiple requests to the same url are made
        
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
    
    private func update(cell: WebsiteTableViewCell, model: WebsiteTableViewCell.Model) {
        DispatchQueue.main.async {
            guard cell.uniqueId == model.uniqueId else { return }
            
            cell.set(model: model)
        }
    }
}
