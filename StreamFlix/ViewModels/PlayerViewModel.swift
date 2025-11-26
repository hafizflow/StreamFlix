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
            isLoading = false
            return
        }
        
        player = AVPlayer(url: url)
        
            // Observe player status
        player?.publisher(for: \.status)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                guard let self = self else { return }
                switch status {
                    case .readyToPlay:
                        self.isLoading = false
                        if let duration = self.player?.currentItem?.duration.seconds,
                           duration.isFinite && duration > 0 {
                            self.duration = duration
                        } else {
                                // If duration is not available, use estimated duration
                            self.duration = Double(self.video.duration)
                        }
                    case .failed:
                        self.errorMessage = "Failed to load video"
                        self.isLoading = false
                    default:
                        break
                }
            }
            .store(in: &cancellables)
        
            // Observe duration changes
        player?.currentItem?.publisher(for: \.duration)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] duration in
                guard let self = self else { return }
                if duration.seconds.isFinite && duration.seconds > 0 {
                    self.duration = duration.seconds
                }
            }
            .store(in: &cancellables)
        
            // Add time observer - dispatch to main actor
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self = self else { return }
            Task { @MainActor in
                if time.seconds.isFinite {
                    self.currentTime = time.seconds
                }
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
        guard time.isFinite && time >= 0 && time <= duration else { return }
        let cmTime = CMTime(seconds: time, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        player?.seek(to: cmTime)
    }
    
    func skipForward(_ seconds: Double = 10) {
        guard duration > 0 else { return }
        let newTime = min(currentTime + seconds, duration)
        seek(to: newTime)
    }
    
    func skipBackward(_ seconds: Double = 10) {
        guard duration > 0 else { return }
        let newTime = max(currentTime - seconds, 0)
        seek(to: newTime)
    }
    
    deinit {
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
        }
        player?.pause()
        player = nil
    }
}
