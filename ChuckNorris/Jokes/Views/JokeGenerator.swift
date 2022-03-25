import SwiftUI

struct JokeGenerator: View {
    
    @ObservedObject var viewModel: RandomJokeGeneratorViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("ViewBackground").edgesIgnoringSafeArea([.top, .leading, .trailing])
                Button(action: {
                    viewModel.load()
                })
                {
                    ZStack {
                        Circle()
                            .fill(Color("AccentColor"))
                            .padding(20)
                        
                        Circle()
                            .fill(Color("ButtonColor"))
                            .padding(40)
                        
                        if (self.viewModel.isLoading) {
                            ProgressView().padding(30)
                        }
                        else
                        {
                            Text("?")
                                .font(.system(size: 88.0)).bold()
                                .padding(.all, 100)
                                .foregroundColor(Color.black)
                                .background(Color("ButtonColor"))
                                .clipShape(Circle())
                        }
                    }
                }
                .padding(.bottom, 30)
                
                .navigationTitle("app-title")
                
                .alert(isPresented: Binding<Bool>(get: { self.viewModel.joke != nil || self.viewModel.errorMessageKey.isEmpty == false }, set: { _ in }))
                    {
                        if self.viewModel.joke != nil {
                            return Alert(title: Text("joke-display-title"),
                              message: Text(self.viewModel.joke!.joke),
                                  dismissButton: .default(Text("joke-dismiss-action"), action: {
                                        self.viewModel.joke = nil
                            }))
                        } else {
                            return Alert(title: Text("joke-load-problem-title"),
                              message: Text(LocalizedStringKey(self.viewModel.errorMessageKey)),
                                  dismissButton: .default(Text("joke-load-problem-dismiss-action"), action: {
                                        self.viewModel.errorMessageKey = ""
                            }))
                        }
                    }
                
                Spacer()
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct JokeGenerator_Previews: PreviewProvider {
    static var previews: some View {
        JokeGenerator(viewModel: RandomJokeGeneratorViewModel(repository: StubChuckNorrisJokeRepository(), profileService: InMemoryProfileService()))
    }
}
