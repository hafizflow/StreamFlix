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
                        // Safe slider with valid range
                    if viewModel.duration > 0 {
                        Slider(
                            value: Binding(
                                get: { viewModel.currentTime },
                                set: { viewModel.seek(to: $0) }
                            ),
                            in: 0...viewModel.duration
                        )
                        .tint(.red)
                    } else {
                            // Placeholder while duration loads
                        Slider(value: .constant(0), in: 0...1)
                            .tint(.red)
                            .disabled(true)
                    }
                    
                    HStack {
                        Text(viewModel.currentTime.formatAsTime())
                        Spacer()
                        Text(viewModel.duration > 0 ? viewModel.duration.formatAsTime() : "--:--")
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
                    .disabled(viewModel.duration <= 0)
                    
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
                    .disabled(viewModel.duration <= 0)
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
