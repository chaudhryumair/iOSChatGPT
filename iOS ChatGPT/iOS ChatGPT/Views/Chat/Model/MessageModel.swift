//
//  Untitled.swift
//  iOS ChatGPT
//
//  Created by Chaudhry Umair on 02/06/2025.
//

import Foundation

struct MessageModel: Identifiable {
    let id = UUID()
       let content: String
       let isUser: Bool
       let time: String

       init(content: String, isUser: Bool) {
           self.content = content
           self.isUser = isUser
           let formatter = DateFormatter()
           formatter.dateFormat = "HH:mm"
           self.time = formatter.string(from: Date())
       }
   }
