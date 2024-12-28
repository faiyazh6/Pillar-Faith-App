import SwiftUI

struct AIPriestView: View {
    @Binding var selectedTab: Tab
    @State private var inputText: String = ""
    @State private var chatMessages: [ChatMessage] = []
    @State private var isTyping: Bool = false
    @State private var isLoading: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            // Chat Interface
            VStack(spacing: 16) {
                if chatMessages.isEmpty {
                    // Placeholder when no messages are present
                    VStack {
                        Image(systemName: "bubble.left.and.bubble.right.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray.opacity(0.5))
                        Text("Ask your AI Priest a question!")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 50)
                } else {
                    // Chat messages
                    ScrollView {
                        ForEach(chatMessages) { message in
                            HStack {
                                if message.isUser {
                                    Spacer()
                                    Text(message.text)
                                        .padding()
                                        .background(Color.brown.opacity(0.2))
                                        .cornerRadius(16)
                                        .foregroundColor(.black)
                                        .frame(maxWidth: UIScreen.main.bounds.width * 0.7, alignment: .trailing)
                                } else {
                                    Text(message.text)
                                        .padding()
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(16)
                                        .foregroundColor(.black)
                                        .frame(maxWidth: UIScreen.main.bounds.width * 0.7, alignment: .leading)
                                    Spacer()
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 4)
                        }
                    }
                    .padding(.top, 16)
                }
            }
            .background(Color(UIColor.systemBackground))
            .cornerRadius(16)
            .animation(.easeInOut, value: chatMessages.count)

            // Input Section
            HStack {
                TextField("Ask AI anything...", text: $inputText, onEditingChanged: { editing in
                    isTyping = editing
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.leading, 16)

                Button(action: {
                    sendMessage()
                }) {
                    if isLoading {
                        ProgressView()
                            .padding()
                            .background(Color.brown)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    } else {
                        Image(systemName: "arrow.up.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .padding()
                            .background(Color.brown)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
                .padding(.trailing, 16)
                .disabled(isLoading) // Disable the button while loading
            }
            .padding(.vertical, 16)
            .background(Color(UIColor.systemBackground).shadow(radius: 4))

            // Task Manager
            TaskManagerView(selectedTab: $selectedTab)
        }
        .padding(.bottom, 16)
        .background(Color(UIColor.systemBackground))
        .navigationBarBackButtonHidden(true)
        .edgesIgnoringSafeArea(.bottom)
    }

    // Function to send a message
    private func sendMessage() {
        guard !inputText.isEmpty else { return }

        // Add the user message to the chat
        let userMessage = ChatMessage(id: UUID(), text: inputText, isUser: true)
        chatMessages.append(userMessage)
        inputText = ""

        // Fetch AI Response
        fetchResponse(for: userMessage.text)
    }

    // Function to Fetch GPT Response
    private func fetchResponse(for query: String) {
        isLoading = true
        let apiKey = "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"

        guard !apiKey.isEmpty else {
            isLoading = false
            chatMessages.append(ChatMessage(id: UUID(), text: "Error: Missing API Key.", isUser: false))
            return
        }

        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters: [String: Any] = [
            "model": "gpt-4",
            "messages": [["role": "user", "content": query]],
            "max_tokens": 150
        ]

        guard let body = try? JSONSerialization.data(withJSONObject: parameters) else {
            isLoading = false
            chatMessages.append(ChatMessage(id: UUID(), text: "Error: Failed to encode request.", isUser: false))
            return
        }
        request.httpBody = body

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
                if let error = error {
                    chatMessages.append(ChatMessage(id: UUID(), text: "Error: \(error.localizedDescription)", isUser: false))
                } else if let data = data {
                    if let result = try? JSONDecoder().decode(OpenAIResponse.self, from: data) {
                        let responseText = result.choices.first?.message.content ?? "No response received."
                        chatMessages.append(ChatMessage(id: UUID(), text: responseText, isUser: false))
                    } else {
                        chatMessages.append(ChatMessage(id: UUID(), text: "Error parsing response.", isUser: false))
                    }
                }
            }
        }.resume()
    }
}

// Chat Message Model
struct ChatMessage: Identifiable {
    let id: UUID
    let text: String
    let isUser: Bool
}

// Response Model
struct OpenAIResponse: Decodable {
    struct Choice: Decodable {
        struct Message: Decodable {
            let content: String
        }
        let message: Message
    }
    let choices: [Choice]
}
