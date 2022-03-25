import SwiftUI

struct JokeList: View {
    
    @ObservedObject var viewModel: JokeListViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("ViewBackground").edgesIgnoringSafeArea([.top, .leading, .trailing])
                ScrollView {
                    LazyVStack {
                        ForEach(self.viewModel.jokes) { joke in
                            JokeListItem(joke: joke)
                                .onAppear {
                                    if (self.viewModel.jokes.last == joke) {
                                        self.viewModel.loadMore()
                                    }
                                }
                        }
                    }
                    if (self.viewModel.isLoading) {
                        ProgressView().padding(30)
                    }
                    if (self.viewModel.errorMessageKey.isEmpty == false) {
                        Text(LocalizedStringKey(self.viewModel.errorMessageKey))
                    }
                }
                .navigationTitle("joke-list-title")
            }
        }
        .navigationViewStyle(.stack)
        .searchable(text: $viewModel.search)
        .onAppear {
            self.viewModel.loadMore()
            
        }
    }
}

struct JokeList_Previews: PreviewProvider {
    static var previews: some View {
        JokeList(viewModel:JokeListViewModel(repository: StubChuckNorrisJokeRepository(), profileService: InMemoryProfileService()))
    }
}
