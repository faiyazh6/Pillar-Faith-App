import SwiftUI

struct SetGoalsView: View {
    @Environment(\.presentationMode) var presentationMode // For dismissing the current view

    // Persistent storage using @AppStorage
    @AppStorage("selectedAgeGroup") private var selectedAgeGroup: String = ""
    @AppStorage("selectedGoal") private var selectedGoal: String = ""
    @AppStorage("lifeChallenge") private var lifeChallenge: String = ""

    let ageGroups = ["Under 18", "18 - 24", "25 - 34", "35 - 44", "45 - 54"]
    let goalOptions = ["Spiritual Growth", "Deeper Faith", "Daily Inspiration", "Improved Relationships"]

    var body: some View {
        VStack(spacing: 20) {
            // Header Section
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) { // Adjusted spacing for tighter alignment
                        Button(action: {
                            presentationMode.wrappedValue.dismiss() // Go back to the previous screen
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.black)
                        }

                        Text("Setting your Goals")
                            .font(.title3)
                            .fontWeight(.semibold)
                    }

                    Text("What do you hope to achieve?")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                // Progress Indicator
                HStack {
                    Rectangle()
                        .frame(height: 4)
                        .foregroundColor(.brown)
                        .cornerRadius(2)
                        .frame(maxWidth: .infinity)

                    Rectangle()
                        .frame(height: 4)
                        .foregroundColor(.brown)
                        .cornerRadius(2)
                        .frame(maxWidth: .infinity)
                }

                Text("Step 2 of 2")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)

            // Main Form Section
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Age Group Section (Checkbox)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Age Group")
                            .font(.subheadline)

                        ForEach(ageGroups, id: \.self) { ageGroup in
                            Button(action: {
                                selectedAgeGroup = ageGroup // Persist selection
                            }) {
                                HStack {
                                    Image(systemName: selectedAgeGroup == ageGroup ? "checkmark.square.fill" : "square")
                                        .foregroundColor(selectedAgeGroup == ageGroup ? .brown : .gray)
                                    Text(ageGroup)
                                        .foregroundColor(.primary)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                    .padding(.horizontal, 16)

                    // Dropdown Menu for Main Goal
                    VStack(alignment: .leading, spacing: 8) {
                        Text("What’s your main goal with this app?")
                            .font(.subheadline)

                        Menu {
                            ForEach(goalOptions, id: \.self) { goal in
                                Button(goal) {
                                    selectedGoal = goal // Persist selection
                                }
                            }
                        } label: {
                            HStack {
                                Text(selectedGoal.isEmpty ? "Select option" : selectedGoal)
                                    .foregroundColor(selectedGoal.isEmpty ? .gray : .primary)
                                    .font(.subheadline)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.6), lineWidth: 1))
                        }
                    }
                    .padding(.horizontal, 16)

                    // Text Area for Life Challenges
                    VStack(alignment: .leading, spacing: 8) {
                        Text("What is the life challenge you are facing today?")
                            .font(.subheadline)

                        TextEditor(text: $lifeChallenge)
                            .frame(height: 100)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.6), lineWidth: 1))
                            .foregroundColor(.primary)
                            .font(.subheadline)
                    }
                    .padding(.horizontal, 16)
                }
            }

            // Navigation Buttons
            HStack(spacing: 16) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss() // Go back to the previous screen
                }) {
                    Text("Previous")
                        .font(.subheadline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                        .foregroundColor(.gray)
                }

                NavigationLink(destination: BibleUsageView()) {
                    Text("Next")
                        .font(.subheadline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.brown)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .navigationBarBackButtonHidden(true) // Hides the default back button
        .background(Color(UIColor.systemBackground))
    }
}
