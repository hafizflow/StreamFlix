import Foundation

struct Video: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let thumbnailURL: String
    let videoURL: String // HLS stream URL
    let duration: Int // in seconds
    let category: String
    let releaseYear: Int
    let rating: Double
    
    enum CodingKeys: String, CodingKey {
        case id, title, description, duration, category, rating
        case thumbnailURL = "thumbnail_url"
        case videoURL = "video_url"
        case releaseYear = "release_year"
    }
}

struct VideoCategory: Identifiable {
    let id = UUID()
    let name: String
    let videos: [Video]
}

    // Sample data for testing
extension Video {
    static let sampleVideos: [Video] = [
        Video(
            id: "1",
            title: "Big Buck Bunny",
            description: "A large and lovable rabbit deals with three tiny bullies, led by a flying squirrel, who are determined to squelch his happiness.",
            thumbnailURL: "https://picsum.photos/seed/1/400/600",
            videoURL: Constants.SampleVideos.bigBuckBunny,
            duration: 596,
            category: "Animation",
            releaseYear: 2008,
            rating: 4.5
        ),
        Video(
            id: "2",
            title: "Sintel",
            description: "A lonely young woman, Sintel, helps and befriends a dragon, whom she calls Scales. But when he is kidnapped, Sintel decides to embark on a dangerous quest to find her lost friend.",
            thumbnailURL: "https://picsum.photos/seed/2/400/600",
            videoURL: Constants.SampleVideos.sintel,
            duration: 888,
            category: "Fantasy",
            releaseYear: 2010,
            rating: 4.7
        ),
        Video(
            id: "3",
            title: "Apple Test Stream",
            description: "High-quality HLS test stream provided by Apple for development purposes.",
            thumbnailURL: "https://picsum.photos/seed/3/400/600",
            videoURL: Constants.SampleVideos.appleTestStream,
            duration: 1800,
            category: "Documentary",
            releaseYear: 2024,
            rating: 4.0
        )
    ]
}
