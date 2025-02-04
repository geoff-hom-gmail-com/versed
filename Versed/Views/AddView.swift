import SwiftUI
import SwiftData

// (Goal) The user can add text to know.
// (Goal) The user adds everything from her reference now. (e.g., Bible app) Then, she can focus on our app. (e.g., stanzas)
struct AddView: View {
    // MARK: - (body)
    var body: some View {
        // (Note) NavigationStack used so the dev can easily have buttons to save/reset.
        NavigationStack {
            Form {
                TextFieldSection(for: .before, text: $beforeText)
                TextFieldSection(for: .goal, text: $goalText)
                TextFieldSection(for: .after, text: $afterText)
                TextFieldSection(for: .reference, text: $referenceText)
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    resetButton
                }
                ToolbarItem(placement: .confirmationAction) {
                    doneButton
                }
            }
            .scrollDismissesKeyboard(.immediately)
        }
    }
    
    // MARK: - (state properties)
    @State private var beforeText: String = ""
    @State private var goalText: String = ""
    @State private var afterText: String = ""
    @State private var referenceText: String = ""

    // MARK: - (buttons)

    private var resetButton: some View {
        Button(AppConstant.Label.reset) {
            reset()
        }
        .disabled(isNoText)
    }
    
    private var doneButton: some View {
        Button(AppConstant.Label.done) {
            // (Goal) The text has the right index.
            var newIndex = 0
            if let maxIndex = userTextsOrderReversed.first?.index {
                newIndex = maxIndex + 1
            }
            
            let passage = Passage(index: newIndex,
                                  before: beforeText,
                                  goal: goalText,
                                  after: afterText,
                                  reference: referenceText)
            modelContext.insert(passage)
            
            // (Note) Not sure if needed on device. But, in Xcode preview, helps.
            do {
                try modelContext.save()
            } catch {
                print("Failed to save: \(error)")
            }
                                    
            reset()
        }
        .disabled(isNoText)
    }

    // (Goal) The user sees the view reset.
    // (Note) Was worried about this being too abrupt. But seems okay.
    private func reset() {
        inputTexts.forEach { $0.wrappedValue = "" }
    }
    
    // (Goal) When are buttons disabled? If no text.
    private var isNoText: Bool {
        inputTexts.allSatisfy { $0.wrappedValue.isEmpty }
    }
    
    // (Note) Why not [String]? Won't work in reset().
    private var inputTexts: [Binding<String>] {
        [$beforeText, $goalText, $afterText, $referenceText]
    }

    @Query(filter: #Predicate<Passage> { $0.isExample == false },
           sort: \.index, order: .reverse)
    var userTextsOrderReversed: [Passage]
    
    @Environment(\.modelContext) private var modelContext
}

// MARK: - (preview)
#Preview {
    AddView()
}
