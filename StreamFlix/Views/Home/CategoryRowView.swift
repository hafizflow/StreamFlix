import SwiftUI

struct CategoryRowView: View {
    let category: VideoCategory
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(category.name)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(category.videos) { video in
                        NavigationLink(destination: VideoDetailView(video: video)) {
                            VideoCardView(video: video)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
