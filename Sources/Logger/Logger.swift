//
//  Logger.swift
//  VaporApp
//
//  Created by Petr Pavlik on 04/10/16.
//
//

import Foundation


import Vapor
import Console

public class Logger {
    
    public static func log(content: String, file: String = #file, line: Int = #line, function: String = #function) {
        
        let data: [String : Any] = [
            "content": content,
            "file": file,
            "line": line,
            "function": function,
            "date": "\(Date())",
            "thread": [
                "name": Thread.current.name != nil ? Thread.current.name! : "unknown",
                "callStack": Thread.callStackSymbols
            ]
        ]
        
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: URL(string: "https://swiftylogger-7b8d6.firebaseio.com/customers/1/1/logs.json")!)
        request.httpMethod = "POST"
        request.httpBody = try! JSONSerialization.data(withJSONObject: data, options: [])
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
        }
        task.resume()
        
    }
}

class VaporLogger: Log {
    
    init(forwardLog: Log = ConsoleLogger(console: Terminal(arguments: CommandLine.arguments))) {
        self.forwardLog = forwardLog
    }
    
    private let forwardLog: Log
    
    public var enabled: [LogLevel] = LogLevel.all
    
    func log(_ level: LogLevel, message: String, file: String, function: String, line: Int) {
        forwardLog.log(level, message: message, file: file, function: function, line: line)
        if enabled.contains(level) {
            Logger.log(content: message, file: file, line: line, function: function)
        }
    }
}
