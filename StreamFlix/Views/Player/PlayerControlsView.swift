import SwiftUI

struct PlayerControlsView: View {
    @ObservedObject var viewModel: PlayerViewModel
    
    var body: some View {
        VStack {
            Spacer()
            
                // Bottom controls
            VStack(spacing: 16) {
                    // Progress bar
                VStack(spacing: 4) {
                    Slider(
                        value: Binding(
                            get: { viewModel.currentTime },
                            set: { viewModel.seek(to: $0) }
                        ),
                        in: 0...max(viewModel.duration, 1)
                    )
                    .tint(.red)
                    
                    HStack {
                        Text(viewModel.currentTime.formatAsTime())
                        Spacer()
                        Text(viewModel.duration.formatAsTime())
                    }
                    .font(.caption)
                    .foregroundColor(.white)
                }
                
                    // Playback controls
                HStack(spacing: 40) {
                    Button {
                        viewModel.skipBackward()
                    } label: {
                        Image(systemName: "gobackward.10")
                            .font(.title)
                    }
                    
                    Button {
                        viewModel.togglePlayPause()
                    } label: {
                        Image(systemName: viewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .font(.system(size: 60))
                    }
                    
                    Button {
                        viewModel.skipForward()
                    } label: {
                        Image(systemName: "goforward.10")
                            .font(.title)
                    }
                }
                .foregroundColor(.white)
            }
            .padding()
            .background(
                LinearGradient(
                    colors: [.clear, .black.opacity(0.7)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
    }
}
