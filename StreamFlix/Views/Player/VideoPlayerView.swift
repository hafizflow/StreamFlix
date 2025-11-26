import SwiftUI
import AVKit

struct VideoPlayerView: View {
    @StateObject private var viewModel: PlayerViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showControls = true
    @State private var controlsTimer: Timer?
    
    init(video: Video) {
        _viewModel = StateObject(wrappedValue: PlayerViewModel(video: video))
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            if let player = viewModel.player {
                VideoPlayer(player: player)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showControls.toggle()
                        }
                        resetControlsTimer()
                    }
            }
            
            if viewModel.isLoading {
                ProgressView()
                    .tint(.white)
                    .scaleEffect(1.5)
            }
            
            if let error = viewModel.errorMessage {
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 50))
                    Text(error)
                        .multilineTextAlignment(.center)
                }
                .foregroundColor(.white)
                .padding()
            }
            
            if showControls && !viewModel.isLoading {
                PlayerControlsView(viewModel: viewModel)
                    .transition(.opacity)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                }
            }
        }
        .onAppear {
            viewModel.togglePlayPause()
            resetControlsTimer()
        }
        .onDisappear {
            controlsTimer?.invalidate()
        }
    }
    
    private func resetControlsTimer() {
        controlsTimer?.invalidate()
        controlsTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
            withAnimation {
                showControls = false
            }
        }
    }
}
