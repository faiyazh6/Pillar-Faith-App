import SwiftUI

struct BibleStoryDetailView: View {
    let story: BibleStory
    @State private var inputText: String = "" // User input for GPT
    @State private var chatMessages: [ChatMessage] = [] // Chat messages with GPT
    @State private var isLoading: Bool = false // Loading state for GPT responses

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Story Image
                    Image("david_gol_icon")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .cornerRadius(12)
                        .padding(.horizontal)

                    // Story Title
                    Text(story.title)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.horizontal)

                    // Story Content
                    Text(story.content)
                        .font(.body)
                        .padding(.horizontal)
                        .fixedSize(horizontal: false, vertical: true) // Prevent truncation and allow multiline
                        .lineLimit(nil) // Explicitly allow unlimited lines
                }
                .padding(.top)
            }
            
            // Divider between content and chat
            Divider()
            
            // Chat Section
            VStack {
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
                .padding(.top, 8)
            }

            // Input Section
            HStack {
                TextField("send a message...", text: $inputText)
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
                .disabled(isLoading)
            }
            .padding(.vertical, 16)
            .background(Color(UIColor.systemBackground).shadow(radius: 4))
        }
        .navigationTitle(story.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            chatMessages.append(ChatMessage(id: UUID(), text: "What do you think about this story?", isUser: false))
        }
    }

    // MARK: - Chat Management Functions

    private func sendMessage() {
        guard !inputText.isEmpty else { return }

        let userMessage = ChatMessage(id: UUID(), text: inputText, isUser: true)
        chatMessages.append(userMessage)
        inputText = ""

        fetchGPTResponse(for: userMessage.text) // Fetch AI response
    }

    private func fetchGPTResponse(for query: String) {
        isLoading = true
        let apiKey = "sk-proj-<Your-API-Key>"

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
