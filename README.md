# StreamFlix Demo

A professional iOS video streaming application demonstrating OTT platform capabilities.

## Features
- ✅ HLS Video Streaming with AVFoundation
- ✅ Clean MVVM Architecture
- ✅ RESTful API Integration (Mock)
- ✅ Custom Video Player Controls
- ✅ Search Functionality
- ✅ Category-based Browse
- ✅ SwiftUI Modern UI
- ✅ Async/Await Networking

## Architecture
- **MVVM Pattern**: Clear separation of concerns
- **Protocol-Oriented**: Service protocols for testability
- **Combine Framework**: Reactive state management
- **Async/Await**: Modern concurrency

## Technologies
- Swift 5.9+
- SwiftUI
- AVFoundation / AVKit
- Combine
- URLSession
- HLS Streaming

## Video Streaming Details
- Protocol: HTTP Live Streaming (HLS)
- Adaptive bitrate streaming
- Background playback support
- Custom player controls

## Setup
1. Clone repository
2. Open `StreamFlixDemo.xcodeproj`
3. Run on iOS 16.0+ device/simulator
4. No additional dependencies required

## Code Highlights
- **PlayerViewModel.swift**: AVPlayer management with time observers
- **VideoService.swift**: Network layer with async/await
- **HomeViewModel.swift**: State management with Combine
- **VideoPlayerView.swift**: Custom HLS player implementation

## Future Enhancements
- [ ] FairPlay DRM integration
- [ ] Download for offline viewing
- [ ] Picture-in-Picture support
- [ ] tvOS support
- [ ] Analytics integration
- [ ] Continue watching feature

## Contact
Hafizur Rahman
hafizur.rahman.cs@gmail.com
