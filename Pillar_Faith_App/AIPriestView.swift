import SwiftUI
import AVFoundation
import Speech

struct AIPriestView: View {
    @Binding var selectedTab: Tab
    @State private var inputText: String = "" // User input
    @State private var chatMessages: [ChatMessage] = [] // Current chat messages
    @State private var isLoading: Bool = false // Loading state
    @State private var isRecording: Bool = false // Speech recording state
    @State private var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    @State private var recognitionTask: SFSpeechRecognitionTask?
    @State private var audioEngine = AVAudioEngine()
    private let speechSynthesizer = AVSpeechSynthesizer() // For speech output (Text-to-Speech)
    @State private var isSpeechInput: Bool = false // Track if input came from speech

    var body: some View {
        VStack(spacing: 0) {
            // Top Bar with Title and Buttons
            VStack {
                Text("Meet your AI Priest")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top, 16)

                Text("Your spiritual companion for questions, prayers, and reflections.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 16)
            }
            .padding(.horizontal)

            // Chat Interface
            VStack(spacing: 16) {
                if chatMessages.isEmpty {
                    // Placeholder for no messages
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
                    // Show messages
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
                                } else {
                                    Text(message.text)
                                        .padding()
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(16)
                                        .foregroundColor(.black)
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
            .padding(.horizontal, 16)
            .padding(.bottom, 16)

            // Input Section
//            VStack(spacing: 0) {
//                Divider()
//                HStack {
//                    TextField("Ask AI anything/who are you looking for?", text: $inputText)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                        .padding(.leading, 16)
//                    
//                    // Microphone Button for Speech Input
//                    Button(action: {
//                        toggleRecording()
//                    }) {
//                        Image(systemName: isRecording ? "mic.fill" : "mic.slash.fill")
//                            .resizable()
//                            .frame(width: 24, height: 24)
//                            .padding()
//                            .background(isRecording ? Color.red : Color.brown)
//                            .foregroundColor(.white)
//                            .cornerRadius(12)
//                    }
//                    .padding(.trailing, 8)
//
//                    Button(action: {
//                        sendMessage()
//                    }) {
//                        if isLoading {
//                            ProgressView()
//                                .padding()
//                                .background(Color.brown)
//                                .foregroundColor(.white)
//                                .cornerRadius(12)
//                        } else {
//                            Image(systemName: "arrow.up.circle.fill")
//                                .resizable()
//                                .frame(width: 24, height: 24)
//                                .padding()
//                                .background(Color.brown)
//                                .foregroundColor(.white)
//                                .cornerRadius(12)
//                        }
//                    }
//                    .padding(.trailing, 16)
//                    .disabled(isLoading)
//                }
//                .padding(.vertical, 8)
//                .background(Color(UIColor.systemBackground))
//            }
            VStack(spacing: 0) {
                Divider()
                HStack {
                    TextField("Ask AI anything/who are you looking for?", text: $inputText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.leading, 16)

                    // Microphone Button for Speech Input
                    Button(action: {
                        isRecording ? stopRecording() : startRecording() // Toggle recording
                    }) {
                        Image(systemName: isRecording ? "mic.fill" : "mic.slash.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(isRecording ? .red : .brown)
                            .padding()
                    }
                    .padding(.trailing, 8)

                    // Send Button for Text Input
                    Button(action: {
                        isSpeechInput = false // Reset if text input is used
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
                .padding(.vertical, 8)
                .background(Color(UIColor.systemBackground))
            }


            // Task Manager for navigation
            TaskManagerView(selectedTab: $selectedTab)
                .background(Color(UIColor.systemBackground))
        }
        .background(Color(UIColor.systemBackground))
        .navigationBarBackButtonHidden(true)
        .onAppear {
            SFSpeechRecognizer.requestAuthorization { status in
                if status != .authorized {
                    print("Speech recognition not authorized.")
                }
            }
        }
    }

    // MARK: - Chat Management Functions

    private func sendMessage() {
        guard !inputText.isEmpty else { return }

        let userMessage = ChatMessage(id: UUID(), text: inputText, isUser: true)
        chatMessages.append(userMessage)
        inputText = ""

        fetchResponse(for: userMessage.text) // Fetch AI response
    }

    private func fetchResponse(for query: String) {
        isLoading = true
        let apiKey = "sk-proj-<API-KEY>"

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
                        speakText(responseText) // Speak the AI response
                    } else {
                        chatMessages.append(ChatMessage(id: UUID(), text: "Error parsing response.", isUser: false))
                    }
                }
            }
        }.resume()
    }
    
    private func toggleRecording() {
        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }
    
    // MARK: - Text-to-Speech Function
    private func speakText(_ text: String) {
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: .immediate)
        }
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5 // Adjust the speed as needed
        speechSynthesizer.speak(utterance)
    }
    
//    private func startRecording() {
//        guard let speechRecognizer = speechRecognizer, speechRecognizer.isAvailable else {
//            print("Speech recognizer not available.")
//            return
//        }
//
//        isRecording = true
//        let request = SFSpeechAudioBufferRecognitionRequest()
//
//        let inputNode = audioEngine.inputNode
//        let recordingFormat = inputNode.outputFormat(forBus: 0)
//        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
//            request.append(buffer)
//        }
//
//        audioEngine.prepare()
//        try? audioEngine.start()
//
//        recognitionTask = speechRecognizer.recognitionTask(with: request) { result, error in
//            if let result = result {
//                inputText = result.bestTranscription.formattedString
//            }
//            if error != nil || result?.isFinal == true {
//                self.stopRecording()
//            }
//        }
//    }
    
    private func startRecording() {
        SFSpeechRecognizer.requestAuthorization { status in
            guard status == .authorized else {
                chatMessages.append(ChatMessage(id: UUID(), text: "Speech recognition not authorized.", isUser: false))
                return
            }
        }

        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try? audioSession.setActive(true, options: .notifyOthersOnDeactivation)

        let inputNode = audioEngine.inputNode
        let recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                inputText = result.bestTranscription.formattedString
                if result.isFinal {
                    stopRecording()
                    sendMessage() // Send the final transcribed message
                }
            } else if let error = error {
                print("Error: \(error.localizedDescription)")
                stopRecording()
            }
        }

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            recognitionRequest.append(buffer)
        }
        audioEngine.prepare()
        try? audioEngine.start()
        isRecording = true
    }

    private func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionTask?.cancel()
        isRecording = false
    }
    
    private func speakResponse(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5 // Adjust the speech rate if needed
        speechSynthesizer.speak(utterance)
    }
}

// MARK: - Supporting Models

struct ChatMessage: Identifiable {
    let id: UUID
    let text: String
    let isUser: Bool
}

struct OpenAIResponse: Decodable {
    struct Choice: Decodable {
        struct Message: Decodable {
            let content: String
        }
        let message: Message
    }
    let choices: [Choice]
}
