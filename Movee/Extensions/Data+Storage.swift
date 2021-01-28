//
//  Data+Storage.swift
//  Movee
//
//  Created by jjurlits on 1/10/21.
//

import Foundation

extension Data {
    func save(toFile filename: String) {
        if let documentDirectory =
            FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask).first {
            let pathWithFileName = documentDirectory.appendingPathComponent(filename)
            do {
                try self.write(to: pathWithFileName)
            } catch {
                print(error)
            }
        }
    }
    
    static func load(fromFile filename: String) -> Data? {
        if let documentDirectory =
            FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask).first {
            let pathWithFileName = documentDirectory.appendingPathComponent(filename)
            print(pathWithFileName)
            return try? Data(contentsOf: pathWithFileName, options: .mappedIfSafe)
        }
        return nil
    }
}
