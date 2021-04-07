//
//  WikipediaClient.swift
//  Movee
//
//  Created by jjurlits on 4/2/21.
//

import Foundation

class WikipediaClient: ApiService {
    private let defaultLocale = "en"
    let locale = Locale.current.languageCode ?? "en"
            
    func pageQueryUrl(title: String) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "\(defaultLocale).wikipedia.org"
        components.path = "/w/api.php"
        components.queryItems = [
            URLQueryItem(name: "action", value: "query"),
            URLQueryItem(name: "titles", value: title),
            URLQueryItem(name: "prop", value: "langlinks"),
            URLQueryItem(name: "redirects", value: "true"),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "utf8", value: ""),
            URLQueryItem(name: "lllimit", value: "500")
        ]
        return components.url
    }
    
    func findPage(withTitle title: String, localized: Bool = true, completion: @escaping (String?) -> Void) {
        guard let url = pageQueryUrl(title: title) else { return }
        
        fetch(url: url) { (result: Result<SearchResult, Error>) in
            switch result {
            case .success(let searchResult):
                DispatchQueue.main.async {
                    if localized && self.locale != self.defaultLocale {
                        completion(searchResult.query.firstPage?.localizedTitle(locale: self.locale))
                    } else {
                        completion(searchResult.query.firstPage?.title)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func getPageUrl(_ title: String) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "\(locale).m.wikipedia.org"
        components.path = "/w/index.php"
        components.queryItems = [URLQueryItem(name: "search", value: title)]
        return components.url
    }
    
    static let shared = WikipediaClient()
    private override init() { }
}

extension WikipediaClient {
    struct SearchResult: Decodable {
        var query: Query
    }
    
    struct Query: Decodable {
        var pages: [String: Page]
        
        var firstPage: Page? {
            return pages.first?.value
        }
    }
    
    struct Page: Decodable {
        var title: String
        var langlinks: [LangLink]?
        
        func localizedTitle(locale: String) -> String? {
            langlinks?.first(where: { $0.lang == locale })?.title
        }
    }
    
    struct LangLink: Decodable {
        var lang: String
        var title: String
        
        enum CodingKeys: String, CodingKey {
            case title = "*"
            case lang
        }
    }
}
