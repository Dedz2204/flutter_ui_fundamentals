import 'package:supabase_flutter/supabase_flutter.dart';

// Model profil pengguna
class UserProfile {
  final String id;
  final String email;
  final String name;
  final String role;

  const UserProfile({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
  });

  // Pemeriksaan role pengguna
  bool get isSeeker => role == 'seeker';

  bool get isOwner => role == 'owner';

  bool get isAdmin => role == 'admin';

  // Mengubah data Supabase menjadi UserProfile
  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] as String,
      email: (map['email'] ?? '') as String,
      name: (map['name'] ?? '') as String,
      role: (map['role'] ?? 'seeker') as String,
    );
  }
}

// Service untuk mengambil profil pengguna
class ProfileService {
  final SupabaseClient _client = Supabase.instance.client;

  // Mengambil profil pengguna yang sedang login
  Future<UserProfile?> getMyProfile() async {
    final user = _client.auth.currentUser;

    if (user == null) {
      return null;
    }

    final data = await _client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    if (data == null) {
      return null;
    }

    return UserProfile.fromMap(data);
  }
}