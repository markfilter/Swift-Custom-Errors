//
//  MainController.swift
//  Custom Error Handling
//
//  Created by Mark Filter on 8/29/18.
//  Copyright © 2018 MarkZFilter.com. All rights reserved.
//

import UIKit

struct FileContents: Codable {
    var secretPassword: String? = nil
}

class MainController: UIViewController {
    
    // MARK: - Injections
    var fileSystemClient = FileSystemClient.shared
    // Properties
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var errorOutputLabel: UILabel!
    @IBOutlet var secretPasswordLabel: UILabel!
    
    // MARK: - Lifecycle Callbacks
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        secretPasswordLabel.text = ""
        do {
            try fileSystemClient.save(contents: "MarkZFilter.com", to: "super-secret-password", withExtention: "txt")
            clearErrorMessage()
            
        } catch FileSystemError.fileIOException(let message) {
            errorOutputLabel.text = message
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func clearErrorMessage() {
        errorOutputLabel.text = ""
    }

    // MARK: - Actions
    
    @IBAction func handlerSaveButtonTapped(_ sender: UIButton) {
        do {
            try fileSystemClient.save(contents: passwordTextField?.text ?? "", to: "super-secret-password", withExtention: "txt")
            clearErrorMessage()
            
        } catch FileSystemError.fileIOException(let message) {
            errorOutputLabel.text = message
        } catch {
            print(error.localizedDescription)
        }
        passwordTextField?.text = ""
    }
    
    
    @IBAction func handlerLoadProperFileTapped(_ sender: UIButton) {
        do {
            
            guard let contents = try fileSystemClient.loadFile(with: "super-secret-password", fileExtension: "txt") as? FileContents else {
                return
            }

            secretPasswordLabel.text = contents.secretPassword
            clearErrorMessage()
        } catch FileSystemError.fileIOException(let message) {
            errorOutputLabel.text = message
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func handlerLoadCorruptedFileTapped(_ sender: UIButton) {
        do {
            
            guard let contents = try fileSystemClient.loadFile(with: "corrupted-file", fileExtension: "txt") as? FileContents else {
                return
            }
            
            secretPasswordLabel.text = contents.secretPassword
            clearErrorMessage()
        } catch FileSystemError.fileIOException(let message) {
            errorOutputLabel.text = message
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    @IBAction func hanlderLoadEmptyFileTapped(_ sender: UIButton) {
        do {
            guard let contents = try fileSystemClient.loadFile(with: "super-secret-password-empty", fileExtension: "txt") as? FileContents else {
                return
            }
            secretPasswordLabel.text = contents.secretPassword
            clearErrorMessage()
        } catch FileSystemError.fileIOException(let message) {
            errorOutputLabel.text = message
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    @IBAction func handlerWrongFileTapped(_ sender: UIButton) {
        do {
            guard let contents = try fileSystemClient.loadFile(with: "name", fileExtension: "txt") as? FileContents else {
                return
            }
            secretPasswordLabel.text = contents.secretPassword
            clearErrorMessage()
        } catch FileSystemError.fileIOException(let message) {
            errorOutputLabel.text = message
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
}

