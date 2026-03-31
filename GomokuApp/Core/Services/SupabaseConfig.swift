import Foundation

struct SupabaseConfig {
    static let supabaseURL = "https://your-project.supabase.co"
    static let supabaseKey = "your-anon-key"
    
    static func createClient() -> SupabaseClient {
        guard let url = URL(string: supabaseURL) else {
            fatalError("Invalid Supabase URL")
        }
        return SupabaseClient(supabaseURL: url, supabaseKey: supabaseKey)
    }
}