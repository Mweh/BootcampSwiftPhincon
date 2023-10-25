
enum UserError: Error{
    case badID, networkFailed
}

func getUser(id: Int) throws -> String{
    throw UserError.networkFailed
}

if let user = try? getUser(id: 23) {
    print("User: \(user)")
    //try? can convert error/throw func to return optional
}

let user = (try? getUser(id: 23)) ?? "Anonymous"
print("User: \(user)")

/*
 You’ll find try? is mainly used in three places:

 In combination with guard let to exit the current function if the try? call returns nil.
 In combination with nil coalescing to attempt something or provide a default value on failure.
 When calling any throwing function without a return value, when you genuinely don’t care if it succeeded or not – maybe you’re writing to a log file or sending analytics to a server, for example.
 */

func getNetworkFailed(network: String) -> Str
