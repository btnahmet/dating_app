// Firebase service - şimdilik devre dışı
// Firebase bağlantısı için gerekli dependency'ler eklendiğinde aktif edilecek

class FirebaseService {
  // TODO: Firebase bağlantısı için gerekli dependency'ler eklendiğinde aktif edilecek
  
  static Future<void> initialize() async {
    // Firebase.initializeApp();
  }

  static Future<dynamic> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    throw UnimplementedError('Firebase bağlantısı henüz aktif değil');
  }

  static Future<dynamic> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    throw UnimplementedError('Firebase bağlantısı henüz aktif değil');
  }

  static Future<void> signOut() async {
    throw UnimplementedError('Firebase bağlantısı henüz aktif değil');
  }

  static dynamic get currentUser => null;

  static Stream<dynamic> get authStateChanges => const Stream.empty();
} 