import AVFoundation
import Combine

@MainActor
class PlayerViewModel: ObservableObject {
    @Published var isPlaying = false
    @Published var currentTime: Double = 0
    @Published var duration: Double = 0
    @Published var isLoading = true
    @Published var errorMessage: String?
    
    var player: AVPlayer?
    private var timeObserver: Any?
    private var cancellables = Set<AnyCancellable>()
    
    let video: Video
    
    init(video: Video) {
        self.video = video
        setupPlayer()
    }
    
    private func setupPlayer() {
        guard let url = URL(string: video.videoURL) else {
            errorMessage = "Invalid video URL"
            return
        }
        
        player = AVPlayer(url: url)
        
        // Observe player status
        player?.publisher(for: \.status)
            .sink { [weak self] status in
                guard let self else { return }
                Task { @MainActor in
                    switch status {
                    case .readyToPlay:
                        self.isLoading = false
                        self.duration = self.player?.currentItem?.duration.seconds ?? 0
                    case .failed:
                        self.errorMessage = "Failed to load video"
                        self.isLoading = false
                    default:
                        break
                    }
                }
            }
            .store(in: &cancellables)
        
        // Add time observer
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self else { return }
            Task { @MainActor in
                self.currentTime = time.seconds
            }
        }
    }
    
    func togglePlayPause() {
        if isPlaying {
            player?.pause()
        } else {
            player?.play()
        }
        isPlaying.toggle()
    }
    
    func seek(to time: Double) {
        let cmTime = CMTime(seconds: time, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        player?.seek(to: cmTime)
    }
    
    func skipForward(_ seconds: Double = 10) {
        let newTime = min(currentTime + seconds, duration)
        seek(to: newTime)
    }
    
    func skipBackward(_ seconds: Double = 10) {
        let newTime = max(currentTime - seconds, 0)
        seek(to: newTime)
    }
    
    deinit {
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
        }
        player?.pause()
    }
}
