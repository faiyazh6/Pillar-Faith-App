import SwiftUI

struct SpiritualJourneyView: View {
    @Environment(\.presentationMode) var presentationMode // For dismissing the current view

    // Persistent storage using @AppStorage
    @AppStorage("selectedRelationship") private var selectedRelationship: String = ""
    @AppStorage("selectedDenomination") private var selectedDenomination: String = ""
    @AppStorage("storedDenominations") private var storedDenominations: String = "" // For checkboxes

    let relationshipOptions = ["Strong", "Moderate", "Weak", "Unsure"]
    let denominationOptions = ["Catholic", "Protestant", "Orthodox", "Non-denominational", "Others"]

    var body: some View {
        VStack(spacing: 16) {
            // Header Section
            VStack(alignment: .leading, spacing: 8) {
                // Back Arrow and Title in HStack
                HStack(spacing: 8) { // Adjust spacing between the arrow and title
                    Button(action: {
                        presentationMode.wrappedValue.dismiss() // Go back to the previous screen
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)
                    }

                    Text("Spiritual Journey")
                        .font(.title3)
                        .fontWeight(.semibold)
                }

                // Subtitle
                Text("Understand Your Relationship with the Bible")
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
                        .foregroundColor(.gray.opacity(0.4))
                        .cornerRadius(2)
                        .frame(maxWidth: .infinity)
                }

                // Step Indicator
                Text("Step 1 of 2")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 16) // Ensure consistent padding for the entire header
            .padding(.top, 16)

            // Main Form Section
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // First Dropdown Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("How would you describe your current relationship with the Bible?")
                            .font(.subheadline)
                            .padding(.horizontal, 16)

                        Menu {
                            ForEach(relationshipOptions, id: \.self) { option in
                                Button(option) {
                                    selectedRelationship = option // Persist selection
                                }
                            }
                        } label: {
                            HStack {
                                Text(selectedRelationship.isEmpty ? "Select option" : selectedRelationship)
                                    .foregroundColor(selectedRelationship.isEmpty ? .gray : .primary)
                                    .font(.subheadline)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.6), lineWidth: 1))
                            .padding(.horizontal, 16)
                        }
                    }

                    // Second Dropdown Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Which Christian denomination do you identify with?")
                            .font(.subheadline)
                            .padding(.horizontal, 16)

                        Menu {
                            ForEach(denominationOptions, id: \.self) { option in
                                Button(option) {
                                    selectedDenomination = option // Persist selection
                                }
                            }
                        } label: {
                            HStack {
                                Text(selectedDenomination.isEmpty ? "Select option" : selectedDenomination)
                                    .foregroundColor(selectedDenomination.isEmpty ? .gray : .primary)
                                    .font(.subheadline)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.6), lineWidth: 1))
                            .padding(.horizontal, 16)
                        }
                    }

                    // Checkbox Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Which Christian denomination do you identify with?")
                            .font(.subheadline)
                            .padding(.horizontal, 16)

                        ForEach(denominationOptions, id: \.self) { denomination in
                            Button(action: {
                                var currentSelections = storedDenominations.split(separator: ",").map(String.init)

                                if currentSelections.contains(denomination) {
                                    currentSelections.removeAll { $0 == denomination }
                                } else {
                                    currentSelections.append(denomination)
                                }

                                // Update storedDenominations
                                storedDenominations = currentSelections.joined(separator: ",")
                            }) {
                                HStack {
                                    Image(systemName: storedDenominations.split(separator: ",").map(String.init).contains(denomination) ? "checkmark.square.fill" : "square")
                                        .foregroundColor(storedDenominations.split(separator: ",").map(String.init).contains(denomination) ? .brown : .gray)
                                    Text(denomination)
                                        .foregroundColor(.primary)
                                }
                                .padding(.vertical, 4)
                                .padding(.horizontal, 16)
                            }
                        }
                    }
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

                NavigationLink(destination: SetGoalsView()) {
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
