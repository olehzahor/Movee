//
//  Bundle+Decoding.swift
//  Movee
//
//  Created by jjurlits on 1/9/21.
//

import Foundation

extension Bundle {
    func decode<T: Decodable>(from filename: String) -> T {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            fatalError("Failed to locate \(filename).json in app bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(filename).json in app bundle.")
        }

        let decoder = JSONDecoder()

        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(filename).json from app bundle.")
        }
        
        return loaded
    }
}
