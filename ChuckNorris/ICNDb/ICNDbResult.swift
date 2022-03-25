import Foundation

/// Represents an 'Internet Chuck Norris Database' API result
struct ICNDbResult<Item: Decodable> : Decodable
{
    let type:String
    let value:Item
}
