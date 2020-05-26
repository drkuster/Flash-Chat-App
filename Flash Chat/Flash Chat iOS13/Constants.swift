
struct K
{
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCell"
    static let registerSegue = "RegisterToChat"
    static let loginSegue = "LoginToChat"
    static let appName = "⚡️FlashChat"
    static let registrationPUID = "RegistrationPU"
    static let loginPUID = "LoginPU"
    
    struct BrandColors
    {
        static let purple = "BrandPurple"
        static let lightPurple = "BrandLightPurple"
        static let blue = "BrandBlue"
        static let lighBlue = "BrandLightBlue"
    }
    
    struct FStore
    {
        static let collectionName = "conversations"
        static let uniqueIDField = "convoID"
        static let bodyField = "body"
        static let senderField = "sender"
        static let dateField = "date"
    }
}
