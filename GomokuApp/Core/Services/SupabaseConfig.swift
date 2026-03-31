import Foundation

struct SupabaseConfig {
    static let supabaseURL = "https://tcqpxgkbqnjgjrtagily.supabase.co"
    static let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRjcXB4Z2ticW5qZ2pydGFnaWx5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQ5NDk1NzgsImV4cCI6MjA5MDUyNTU3OH0.Fdt_j7M_d3mfPB1HWpmhOg0PlXbW7RGu-54I1J7o5Rc"
    
    static var supabaseURLObject: URL? {
        URL(string: supabaseURL)
    }
}