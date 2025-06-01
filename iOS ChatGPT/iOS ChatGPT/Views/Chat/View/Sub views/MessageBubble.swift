//
//  MessageBubble.swift
//  iOS ChatGPT
//
//  Created by Chaudhry Umair on 02/06/2025.
//

import SwiftUI
struct MessageBubble: View {
    let message: MessageModel

    var body: some View {
        HStack(alignment: .bottom) {
            if message.isUser {
                Spacer()
            }

            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .padding()
                    .background(message.isUser ? Color.blue : Color.gray.opacity(0.2))
                    .foregroundColor(message.isUser ? .white : .black)
                    .cornerRadius(16)
                    .frame(maxWidth: 250, alignment: message.isUser ? .trailing : .leading)

                Text(message.time)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }

            if !message.isUser {
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}
