import SwiftUI

struct AutoResponderView: View {
    @State private var rules: [AutoResponseRule] = [
        AutoResponseRule(trigger: "hello", response: "Hello! How can we help you today?"),
        AutoResponseRule(trigger: "price", response: "Our pricing starts at $10/month.")
    ]
    @State private var showingAddRule = false
    @State private var newTrigger = ""
    @State private var newResponse = ""
    
    var body: some View {
        VStack {
            List {
                ForEach(rules) { rule in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(rule.trigger)
                                .font(.headline)
                            Text(rule.response)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Toggle("", isOn: .constant(rule.isActive))
                            .labelsHidden()
                    }
                    .listRowBackground(Color.clear)
                }
                .onDelete(perform: deleteRules)
            }
            .listStyle(PlainListStyle())
            
            Button(action: { showingAddRule = true }) {
                Label("Add Rule", systemImage: "plus.circle.fill")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green.opacity(0.6))
                    .cornerRadius(15)
            }
            .padding()
        }
        .navigationTitle("Autoresponder")
        .sheet(isPresented: $showingAddRule) {
            AddRuleView(rules: $rules)
        }
    }
    
    func deleteRules(at offsets: IndexSet) {
        rules.remove(atOffsets: offsets)
    }
}

struct AddRuleView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var rules: [AutoResponseRule]
    @State private var trigger = ""
    @State private var response = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Rule Details")) {
                    TextField("Trigger Keyword", text: $trigger)
                    TextField("Response Message", text: $response)
                }
            }
            .navigationTitle("New Rule")
            .navigationBarItems(trailing: Button("Save") {
                let newRule = AutoResponseRule(trigger: trigger, response: response)
                rules.append(newRule)
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
