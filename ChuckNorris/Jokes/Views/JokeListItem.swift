import SwiftUI

struct JokeListItem: View {
    
    @ObservedObject var joke: JokeListItemViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                MessageBubble()
                    .fill(Color("FocusColor"))
                
                Text(self.joke.joke)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .padding(.vertical, 10)
                    .padding(.leading, 10)
                    .padding(.trailing, 20)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
}

struct MessageBubble : Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: 0, y: 10))
        path.addQuadCurve(to: CGPoint(x: 10, y: 0), control: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width - 10, y: 10))
        path.addLine(to: CGPoint(x: rect.width - 10, y: rect.height - 10))
        path.addQuadCurve(to: CGPoint(x: rect.width - 20, y: rect.height), control: CGPoint(x: rect.width - 10, y: rect.height))
        path.addLine(to: CGPoint(x: 10, y: rect.height))
        path.addQuadCurve(to: CGPoint(x: 0, y: rect.height - 10), control: CGPoint(x: 0, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: 0))
        
        return path
    }
}

/*struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile(viewModel:ProfileViewModel())
    }
}*/
