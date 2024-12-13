import SwiftUI
import SwiftData

// (Goal) The user can edit any of her verses to improve encoding/retrieval. 
struct EncodeView: View {
    //
    @Environment(\.modelContext) private var modelContext
    
    // (Goal) The user can see example verses, in learning order.
    @Query(filter: #Predicate<Verse> { $0.isExample == true },
           sort: \.order)
    private var exampleVerses: [Verse]
        
    @State private var isMyTextsExpanded: Bool = true
    @State private var isExamplesExpanded: Bool = true
    
//    @Environment(Verses.self) private var verses

    var body: some View {
//        Text("Encode")
        NavigationStack {
            List {
//                Section("My Texts", isExpanded: $isMyTextsExpanded) {
//                    ForEach(verses.myVerses) { verse in
//                        
//                        // This version of NavigationLink separates the view from the data. 
//                        NavigationLink(value: verse) {
//                            // (ToDo) Test with multiline text. Truncate with …. 
//                            Text(verse.rowTitle)
//                            // (ToDo) (Goal) The user can see at a glance how she's doing with her verses. 
//                            // She can see which ones she is reciting well, and maybe deduce why. 
//                            // Which ones she is not reciting well, and deduce why. And know how to improve. E.g., more encoding, better encoding, recitation variety. 
//                            // Which ones are new and still need to be encoded. 
//                            // A custom row with encoding/recite data/scores/gauges? (Understanding? Stamina? symbols? What options are there for Vstack with symbol and text? Maybe Label can already do that, or LabeledContent)
//                        }
//                    }
//                }
//                
//                (ToDo) This section is similar to above. DRY?
                Section("Examples", isExpanded: $isExamplesExpanded) {
                    ForEach(exampleVerses) { verse in
                        NavigationLink(value: verse) {
                            Text(verse.rowTitle)
                        }
                    }
                }
                .task {
                    if exampleVerses.isEmpty {
                        Verse.insertExamples(modelContext: modelContext)
                    }
                }
            }
            .listStyle(.sidebar)
            .navigationDestination(for: Verse.self) {
                VerseDetail(verse: $0)
            }
        }
    }
}

//#Preview {
//    EncodeView()
//}
