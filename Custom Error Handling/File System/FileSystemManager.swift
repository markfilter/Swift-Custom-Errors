//
//  FileSystemClient.swift
//  Custom Error Handling
//
//  Created by Mark Filter on 8/29/18.
//  Copyright © 2018 MarkZFilter.com. All rights reserved.
//

import Foundation

enum FileSystemError: Error {
    case fileIOException(String)
    case saveToFileUnsuccessful(String)
}

class FileSystemClient {
    
    public static let shared = FileSystemClient()
    
    func loadFile(with url: String, fileExtension: String) throws -> Codable {
        
        guard let fileUrl = Bundle.main.url(forResource: url, withExtension: fileExtension) else {
            throw FileSystemError.fileIOException("File was not found with given filename.")
        }
        
        guard let contentsOfFile =  try? String.init(contentsOf: fileUrl, encoding: String.Encoding.utf8) else {
            throw FileSystemError.fileIOException("File was empty.")
        }
        
        if contentsOfFile == "" {
            throw FileSystemError.fileIOException("File was empty.")
        }
        
        let decoder = JSONDecoder()
        guard let fileObject = try? decoder.decode(FileContents.self, from: contentsOfFile.data(using: String.Encoding.utf8)!) else {
            throw FileSystemError.fileIOException("File contents were corrupt.")
        }
        
        return fileObject
    }
    
    func save(contents: String, to url: String, withExtention: String) throws -> Void {
        guard let fileUrl = Bundle.main.url(forResource: url, withExtension: withExtention) else {
            throw FileSystemError.fileIOException("File was not found with given filename.")
        }
        do {
            let encoder = JSONEncoder()
            let fileContents = FileContents(secretPassword: contents)
            let data = try! encoder.encode(fileContents)
            let contentString = String(data: data, encoding: .utf8)!
            try contentString.write(to: fileUrl, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            throw FileSystemError.saveToFileUnsuccessful("There was an error while attempting to save to \(url + "." + withExtention)")
        }
    }
    
}
