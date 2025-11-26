import SwiftUI

struct VideoDetailView: View {
    let video: Video
    @State private var isShowingPlayer = false
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ZStack {
                        AsyncImage(url: URL(string: video.thumbnailURL)) { image in
                            image
                                .resizable()
                                .aspectRatio(16/9, contentMode: .fill)
                        } placeholder: {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .aspectRatio(16/9, contentMode: .fill)
                                .overlay {
                                    ProgressView()
                                }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 250)
                        .clipped()
                        
                        Button {
                            isShowingPlayer = true
                        } label: {
                            Image(systemName: "play.circle.fill")
                                .font(.system(size: 70))
                                .foregroundColor(.white)
                                .shadow(radius: 10)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text(video.title)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                            // Metadata
                        HStack(spacing: 12) {
                            Text(String(video.releaseYear))
                            Text("•")
                            Text(Double(video.duration).formatAsTime())
                            Text("•")
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                Text(String(format: "%.1f", video.rating))
                            }
                        }
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        
                            // Category
                        Text(video.category)
                            .font(.caption)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.appPrimary.opacity(0.2))
                            .foregroundColor(.appPrimary)
                            .clipShape(Capsule())
                        
                            // Description
                        Text("Description")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Text(video.description)
                            .font(.body)
                            .foregroundColor(.gray)
                            .lineSpacing(4)
                    }
                    .padding()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(isPresented: $isShowingPlayer) {
            NavigationStack {
                VideoPlayerView(video: video)
            }
        }
    }
}
