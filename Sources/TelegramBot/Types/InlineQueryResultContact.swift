// Telegram Bot SDK for Swift (unofficial).
// This file is autogenerated by API/generate_wrappers.rb script.

import Foundation
import SwiftyJSON

/// Represents a contact with a phone number. By default, this contact will be sent by the user. Alternatively, you can use input_message_content to send a message with the specified content instead of the contact.
///
/// - SeeAlso: <https://core.telegram.org/bots/api#inlinequeryresultcontact>

public struct InlineQueryResultContact: JsonConvertible {
    /// Original JSON for fields not yet added to Swift structures.
    public var json: JSON

    /// Type of the result, must be contact
    public var type_string: String {
        get { return json["type"].stringValue }
        set { json["type"].stringValue = newValue }
    }

    /// Unique identifier for this result, 1-64 Bytes
    public var id: String {
        get { return json["id"].stringValue }
        set { json["id"].stringValue = newValue }
    }

    /// Contact's phone number
    public var phone_number: String {
        get { return json["phone_number"].stringValue }
        set { json["phone_number"].stringValue = newValue }
    }

    /// Contact's first name
    public var first_name: String {
        get { return json["first_name"].stringValue }
        set { json["first_name"].stringValue = newValue }
    }

    /// Optional. Contact's last name
    public var last_name: String? {
        get { return json["last_name"].string }
        set { json["last_name"].string = newValue }
    }

    /// Optional. Inline keyboard attached to the message
    public var reply_markup: InlineKeyboardMarkup? {
        get {
            let value = json["reply_markup"]
            return value.isNullOrUnknown ? nil : InlineKeyboardMarkup(json: value)
        }
        set {
            json["reply_markup"] = newValue?.json ?? nil
        }
    }

    /// Optional. Content of the message to be sent instead of the contact
    public var input_message_content: InputMessageContent? {
        get {
            let value = json["input_message_content"]
            return value.isNullOrUnknown ? nil : InputMessageContent(json: value)
        }
        set {
            json["input_message_content"] = newValue?.json ?? nil
        }
    }

    /// Optional. Url of the thumbnail for the result
    public var thumb_url: String? {
        get { return json["thumb_url"].string }
        set { json["thumb_url"].string = newValue }
    }

    /// Optional. Thumbnail width
    public var thumb_width: Int? {
        get { return json["thumb_width"].int }
        set { json["thumb_width"].int = newValue }
    }

    /// Optional. Thumbnail height
    public var thumb_height: Int? {
        get { return json["thumb_height"].int }
        set { json["thumb_height"].int = newValue }
    }

    public init(json: JSON = [:]) {
        self.json = json
    }
}
