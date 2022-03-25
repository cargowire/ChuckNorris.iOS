import Foundation

struct ChuckNorrisJoke : Decodable {
    let id:Int
    let joke:String
    let categories:[String]
}
