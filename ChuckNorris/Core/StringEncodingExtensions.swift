import Foundation

extension String {

    var utf8Encoded : Data {
        return Data(self.utf8)
    }

}
