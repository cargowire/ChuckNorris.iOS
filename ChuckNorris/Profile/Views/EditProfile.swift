import SwiftUI

struct EditProfile: View {
    
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("ViewBackground").edgesIgnoringSafeArea([.top, .leading, .trailing])
                Form {
                    Section(header: Text("profile-user-label")) {
                      TextField("profile-firstname-label", text: $viewModel.firstName)
                        if viewModel.firstNameValidationMessage.isEmpty == false {
                            Text(LocalizedStringKey(viewModel.firstNameValidationMessage))
                                .foregroundColor(Color.red)
                        }
                      TextField("profile-lastname-label", text: $viewModel.lastName)
                        if viewModel.lastNameValidationMessage.isEmpty == false {
                            Text(LocalizedStringKey(viewModel.lastNameValidationMessage))
                                .foregroundColor(Color.red)
                        }
                    }
                    Section(header: Text("profile-settings-label")) {
                      Toggle("profile-includeexplicit-label", isOn: $viewModel.includeExplicit)
                    }
                    Text("profile-save-description")
                }.onDisappear {
                    viewModel.save()
                }
                .navigationTitle("profile-title" )
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        EditProfile(viewModel:ProfileViewModel(profileService:InMemoryProfileService()))
    }
}
