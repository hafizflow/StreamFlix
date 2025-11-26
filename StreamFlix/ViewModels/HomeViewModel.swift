import Foundation
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    @Published var categories: [VideoCategory] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchQuery = ""
    @Published var searchResults: [Video] = []
    @Published var isSearching = false
    
    private let videoService: VideoServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(videoService: VideoServiceProtocol = VideoService.shared) {
        self.videoService = videoService
        setupSearchDebounce()
    }
    
    func loadVideos() async {
        isLoading = true
        errorMessage = nil
        
        do {
            categories = try await videoService.fetchVideosByCategory()
            isLoading = false
        } catch {
            errorMessage = "Failed to load videos: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    private func setupSearchDebounce() {
        $searchQuery
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                Task {
                    await self?.performSearch(query: query)
                }
            }
            .store(in: &cancellables)
    }
    
    private func performSearch(query: String) async {
        guard !query.isEmpty else {
            searchResults = []
            isSearching = false
            return
        }
        
        isSearching = true
        
        do {
            searchResults = try await videoService.searchVideos(query: query)
            isSearching = false
        } catch {
            errorMessage = "Search failed: \(error.localizedDescription)"
            isSearching = false
        }
    }
}
