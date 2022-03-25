import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            JokeGenerator(viewModel: try! ChuckNorrisApp.container.resolve())
            .background(Color.blue)
            .tabItem {
                Image(systemName: "shuffle")
                Text("random-title")
            }
            
            JokeList(viewModel: try! ChuckNorrisApp.container.resolve())
            .tabItem {
                Image(systemName: "list.dash")
                Text("list-title")
            }
            
            EditProfile(viewModel: try! ChuckNorrisApp.container.resolve())
            .tabItem {
                Image(systemName: "gearshape.fill")
                Text("settings-title")
            }
            
            .background(Color.purple)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
