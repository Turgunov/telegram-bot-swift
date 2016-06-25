// Telegram Bot SDK for Swift (unofficial).
// This file is autogenerated by API/generate_wrappers.rb script.

import Foundation
import SwiftyJSON

/// Represents a link to a page containing an embedded video player or a video file. By default, this video file will be sent by the user with an optional caption. Alternatively, you can use input_message_content to send a message with the specified content instead of the video.
///
/// - SeeAlso: <https://core.telegram.org/bots/api#inlinequeryresultvideo>

public struct InlineQueryResultVideo: JsonConvertible {
    /// Original JSON for fields not yet added to Swift structures.
    public var json: JSON

    /// Type of the result, must be video
    public var type_string: String {
        get { return json["type"].stringValue }
        set { json["type"].stringValue = newValue }
    }

    /// Unique identifier for this result, 1-64 bytes
    public var id: String {
        get { return json["id"].stringValue }
        set { json["id"].stringValue = newValue }
    }

    /// A valid URL for the embedded video player or video file
    public var video_url: String {
        get { return json["video_url"].stringValue }
        set { json["video_url"].stringValue = newValue }
    }

    /// Mime type of the content of video url, “text/html” or “video/mp4”
    public var mime_type: String {
        get { return json["mime_type"].stringValue }
        set { json["mime_type"].stringValue = newValue }
    }

    /// URL of the thumbnail (jpeg only) for the video
    public var thumb_url: String {
        get { return json["thumb_url"].stringValue }
        set { json["thumb_url"].stringValue = newValue }
    }

    /// Title for the result
    public var title: String {
        get { return json["title"].stringValue }
        set { json["title"].stringValue = newValue }
    }

    /// Optional. Caption of the video to be sent, 0-200 characters
    public var caption: String? {
        get { return json["caption"].string }
        set { json["caption"].string = newValue }
    }

    /// Optional. Video width
    public var video_width: Int? {
        get { return json["video_width"].int }
        set { json["video_width"].int = newValue }
    }

    /// Optional. Video height
    public var video_height: Int? {
        get { return json["video_height"].int }
        set { json["video_height"].int = newValue }
    }

    /// Optional. Video duration in seconds
    public var video_duration: Int? {
        get { return json["video_duration"].int }
        set { json["video_duration"].int = newValue }
    }

    /// Optional. Short description of the result
    public var description: String? {
        get { return json["description"].string }
        set { json["description"].string = newValue }
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

    /// Optional. Content of the message to be sent instead of the video
    public var input_message_content: InputMessageContent? {
        get {
            let value = json["input_message_content"]
            return value.isNullOrUnknown ? nil : InputMessageContent(json: value)
        }
        set {
            json["input_message_content"] = newValue?.json ?? nil
        }
    }

    public init(json: JSON = [:]) {
        self.json = json
    }
}
