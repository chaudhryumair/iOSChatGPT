//
//  ChatViewModel.swift
//  iOS ChatGPT
//
//  Created by Chaudhry Umair on 02/06/2025.
//
import Foundation


class ChatViewModel: ObservableObject {
    @Published var messages: [MessageModel] = []

    private let apiKey = "" // Replace API key safely - you can get it from https://platform.openai.com/api-keys


      func sendMessage(_ text: String) {
          print("📤 Sending prompt: \(text)")

          guard !text.trimmingCharacters(in: .whitespaces).isEmpty else { return }

          let userMessage = MessageModel(content: text, isUser: true)
          DispatchQueue.main.async {
              self.messages.append(userMessage)
          }

          let promptMessages: [[String: String]] = [
              ["role": "system", "content": "You are a helpful assistant."],
              ["role": "user", "content": text]
          ]

          guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
              print("❌ Invalid URL")
              return
          }

          var request = URLRequest(url: url)
          request.httpMethod = "POST"
          request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
          request.setValue("application/json", forHTTPHeaderField: "Content-Type")

          let body: [String: Any] = [
              "model": "gpt-3.5-turbo",
              "messages": promptMessages,
              "temperature": 0.7
          ]

          do {
              request.httpBody = try JSONSerialization.data(withJSONObject: body)
          } catch {
              print("❌ JSON serialization error: \(error.localizedDescription)")
              return
          }

          let task = URLSession.shared.dataTask(with: request) { data, response, error in
              if let error = error {
                  print("❌ Network error: \(error.localizedDescription)")
                  return
              }

              if let httpResponse = response as? HTTPURLResponse {
                  print("📡 Status Code: \(httpResponse.statusCode)")
                  if httpResponse.statusCode != 200 {
                      if let data = data,
                         let errorString = String(data: data, encoding: .utf8) {
                          print("❌ Error Response: \(errorString)")
                      }
                      return
                  }
              }

              guard let data = data else {
                  print("❌ Empty response data")
                  return
              }

              do {
                  if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                     let choices = json["choices"] as? [[String: Any]],
                     let message = choices.first?["message"] as? [String: Any],
                     let content = message["content"] as? String {

                      print("✅ GPT Response: \(content)")

                      let botMessage = MessageModel(content: content.trimmingCharacters(in: .whitespacesAndNewlines), isUser: false)
                      DispatchQueue.main.async {
                          self.messages.append(botMessage)
                      }
                  } else {
                      print("⚠️ Unexpected JSON format")
                      if let raw = String(data: data, encoding: .utf8) {
                          print("🔍 Raw Response: \(raw)")
                      }
                  }
              } catch {
                  print("❌ JSON decode error: \(error)")
              }
          }

          task.resume()
      }
  }
