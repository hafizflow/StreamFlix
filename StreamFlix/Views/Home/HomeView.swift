import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var showSearch = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                
                if viewModel.isLoading {
                    ProgressView("Loading videos...")
                        .tint(.white)
                        .foregroundColor(.white)
                } else if let error = viewModel.errorMessage {
                    VStack(spacing: 16) {
                        Text("Error")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text(error)
                            .multilineTextAlignment(.center)
                        Button("Retry") {
                            Task {
                                await viewModel.loadVideos()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .foregroundColor(.white)
                    .padding()
                } else {
                    ScrollView {
                        VStack(spacing: 24) {
                            ForEach(viewModel.categories) { category in
                                CategoryRowView(category: category)
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
            .navigationTitle("StreamFlix")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showSearch.toggle()
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white)
                    }
                }
            }
            .sheet(isPresented: $showSearch) {
                SearchView(viewModel: viewModel)
            }
            .task {
                await viewModel.loadVideos()
            }
        }
    }
}

struct SearchView: View {
    @ObservedObject var viewModel: HomeViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                
                VStack {
                    if viewModel.isSearching {
                        ProgressView()
                            .tint(.white)
                    } else if viewModel.searchResults.isEmpty && !viewModel.searchQuery.isEmpty {
                        Text("No results found")
                            .foregroundColor(.gray)
                    } else if !viewModel.searchResults.isEmpty {
                        ScrollView {
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))], spacing: 16) {
                                ForEach(viewModel.searchResults) { video in
                                    NavigationLink(destination: VideoDetailView(video: video)) {
                                        VideoCardView(video: video)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $viewModel.searchQuery, prompt: "Search videos")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
}
