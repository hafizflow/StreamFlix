import Foundation

protocol VideoServiceProtocol {
    func fetchVideos() async throws -> [Video]
    func fetchVideosByCategory() async throws -> [VideoCategory]
    func searchVideos(query: String) async throws -> [Video]
}

class VideoService: VideoServiceProtocol {
    static let shared = VideoService()
    private init() {}
    
        // For demo purposes, we'll use local data
        // In production, this would call NetworkService
    func fetchVideos() async throws -> [Video] {
            // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000)
        return Video.sampleVideos
    }
    
    func fetchVideosByCategory() async throws -> [VideoCategory] {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        let videos = Video.sampleVideos
        let categories = Dictionary(grouping: videos, by: { $0.category })
        
        return categories.map { VideoCategory(name: $0.key, videos: $0.value) }
    }
    
    func searchVideos(query: String) async throws -> [Video] {
        try await Task.sleep(nanoseconds: 500_000_000)
        
        let videos = Video.sampleVideos
        return videos.filter {
            $0.title.localizedCaseInsensitiveContains(query) ||
            $0.description.localizedCaseInsensitiveContains(query)
        }
    }
}
