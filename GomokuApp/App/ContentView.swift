import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("首页", systemImage: "house.fill")
                }
                .tag(0)
            
            SkinStoreView()
                .tabItem {
                    Label("皮肤", systemImage: "paintbrush.fill")
                }
                .tag(1)
            
            CheckInView()
                .tabItem {
                    Label("签到", systemImage: "calendar")
                }
                .tag(2)
            
            ProfileView()
                .tabItem {
                    Label("我的", systemImage: "person.fill")
                }
                .tag(3)
        }
        .tint(Color.theme.primary)
    }
}