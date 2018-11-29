//
//  input.swift
//  AoC
//
//  Created by Paul Landers on 11/8/18.
//

import Foundation

enum SolutionState :String {
    case unsolved = "unsolved"
}

struct Solution {
    var partOne = SolutionState.unsolved.rawValue
    var partTwo = SolutionState.unsolved.rawValue
}

struct Storage :Codable {
    var day :Int
    var input :String = SolutionState.unsolved.rawValue
    struct Part :Codable {
        var submittedCount :Int = 0
        var succeeded :Bool = false
        var answer :String = SolutionState.unsolved.rawValue
    }
    var partOne = Part()
    var partTwo = Part()
    var filePath :String { return "\(localFolder)/\(cacheFolderName)/day_\(day).json"}
    
    init(day:Int) {
        self.day = day
        
        if FileManager.default.fileExists(atPath:self.filePath) {
            let decoder = JSONDecoder()
            do {
                self = try decoder.decode(Storage.self, from: FileManager.default.contents(atPath: self.filePath)!)
            } catch {
                print("error trying load json file")
                print(error)
            }
        } else {
            self.save()
        }
    }
    
    func save() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(self)
            try FileManager.default.createDirectory(atPath: "\(localFolder)/\(cacheFolderName)/", withIntermediateDirectories: true, attributes: nil)
            try data.write(to: URL(fileURLWithPath: self.filePath))
        } catch {
            print("error trying to save json file")
            print(error)
        }
    }
}

class Auth {
    var token :String? {
        guard let tok = ProcessInfo.processInfo.environment["SESSION"] else {
            return nil
        }
        return tok
    }
    
    func input(day:Int) -> String {
        if self.token == nil {
            print("[Warning] No session set. Set the SESSION environment variable to your adventofcode session cookie value")
            return manualInput
        }
        
        var store = Storage(day:day)
        
        if store.input == SolutionState.unsolved.rawValue {
            store.input = self.query(address: "\(urlBase)/day/\(day)/input") ?? SolutionState.unsolved.rawValue
            if store.input == SolutionState.unsolved.rawValue {
                print("[Warning] Could not load input from web. Using manualInput.")
                return manualInput
            } else {
                store.save()
            }
        }
        
        return store.input
    }
    
    func check(day:Int, sol:Solution) -> (Bool, Bool) {
        if self.token == nil {
            print("[Warning] No session set. Set the SESSION environment variable to your adventofcode session cookie value")
            return (true, true)
        }
        
        var store = Storage(day:day)
        var part1Submitted = false
//        var part2Submitted = false
        
        if !store.partOne.succeeded && sol.partOne != SolutionState.unsolved.rawValue {
            store.partOne.submittedCount += 1
            let response = self.post(address: "\(urlBase)/day/\(day)/answer", params:["level":"1","answer":sol.partOne]) ?? "[Error] No response from server while submitting solution"
            
            if response.contains("That's the right answer!") {
                store.partOne.succeeded = true
                store.partOne.answer = sol.partOne
                print("[Server] Solution part one verified!")
            } else if response.contains("Did you already complete it?") {
                store.partOne.succeeded = true
                store.partOne.answer = "Unknown. Previously submitted."
            } else {
                print("[Server] Solution part one false")
                print(response[response.lineRange(for: response.range(of: "<article>")!)])
            }
            store.save()
            part1Submitted = true
        }
        
        if !store.partTwo.succeeded && sol.partTwo != SolutionState.unsolved.rawValue {
            if part1Submitted {
                // Submitting both at once triggers a timeout error. wait 12 seconds
                print("[Server] Waiting for timeout before submitting part two.")
                sleep(12)
            }
            store.partTwo.submittedCount += 1
            let response = self.post(address: "\(urlBase)/day/\(day)/answer", params:["level":"2","answer":sol.partTwo]) ?? "[Error] No response from server while submitting solution"
            
            if response.contains("That's the right answer!") {
                store.partTwo.succeeded = true
                store.partTwo.answer = sol.partTwo
                print("[Server] Solution part two verified!")
            } else if response.contains("Did you already complete it?") {
                store.partTwo.succeeded = true
                store.partTwo.answer = "Unknown. Previously submitted."
            } else {
                print("[Server] Solution part two false")
                print(response[response.lineRange(for: response.range(of: "<article>")!)])
            }
            store.save()
//            part2Submitted = true
        }
        
        return (store.partOne.succeeded, store.partTwo.succeeded)
    }

    func query(address: String) -> String? {
        let url = URLRequest(url:URL(string: address)!)
        return query(url: url)
    }
    
    func post(address:String, params:[String:String]) -> String? {
        var url = URLRequest(url:URL(string: address)!)
        url.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        url.httpMethod = "POST"
        let postString = params.reduce("") { (previous, next) -> String in
            return "\(previous)\(previous=="" ? "" : "&")\(next.key)=\(next.value)"
        }
        url.httpBody = postString.data(using: .utf8)
        return query(url: url)
    }
    
    func query(url: URLRequest) -> String? {
        if let session = self.token {
            let cookies = HTTPCookie.cookies(withResponseHeaderFields: ["Set-Cookie": "session=\(session)"], for: url.url!)
            HTTPCookieStorage.shared.setCookies(cookies, for: url.url!, mainDocumentURL: url.url!)
        }
        
        let semaphore = DispatchSemaphore(value: 0)
        
        var result: String?
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            if let err = error {
                print("[Error] \(err)")
            } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("[Error] Code \(httpResponse.statusCode) returned for \(httpResponse)")
            } else if let responseData = data {
                result = String(data: responseData, encoding: String.Encoding.utf8)
                let dumpFile = "\(localFolder)/\(pageDumpFolderName)/\(Date().string(format: "YY-MM-d-HH-mm-ss")).html"
                do {
                    try FileManager.default.createDirectory(atPath: "\(localFolder)/\(pageDumpFolderName)/", withIntermediateDirectories: true, attributes: nil)
                    try responseData.write(to: URL(fileURLWithPath: dumpFile))
                } catch {
                    print("error trying to save http response file")
                    print(error)
                }
            }
            semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
        return result
    }
}
