import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../home/viewmodel/home_view_model.dart';
import '../../home/model/movie_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Beğenilen filmleri yükle
    Future.microtask(() {
      final viewModel = Provider.of<HomeViewModel>(context, listen: false);
      viewModel.loadFavoriteMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(0xFF1F1F1F),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Profil Detayı',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Spacer(),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      foregroundColor: Colors.white,
                    ),
                    child: const Row(
                      children: [
                        Icon(LucideIcons.gem, size: 16),
                        SizedBox(width: 6),
                        Text('Sınırlı Teklif'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 36,
                    backgroundImage: NetworkImage(
                        'https://i.pravatar.cc/150?img=47'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ayça Aydoğan',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'ID: 245677',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Fotoğraf Ekle'),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                'Beğendiğim Filmler',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Consumer<HomeViewModel>(
                  builder: (context, viewModel, child) {
                    if (viewModel.isLoadingFavorites) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    
                    if (viewModel.favoriteMovies.isEmpty) {
                      return const Center(
                        child: Text(
                          'Henüz beğendiğiniz film yok',
                          style: TextStyle(color: Colors.white70),
                        ),
                      );
                    }

                    return GridView.builder(
                      itemCount: viewModel.favoriteMovies.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        mainAxisExtent: 200, // 180'den 200'e çıkardım
                      ),
                      itemBuilder: (context, index) {
                        final movie = viewModel.favoriteMovies[index];
                        return _FavoriteMovieCard(movie: movie);
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _FavoriteMovieCard extends StatelessWidget {
  final MovieModel movie;
  
  const _FavoriteMovieCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Image.network(
              movie.posterUrl,
              height: 120, // Yüksekliği azalttım
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 120, // Yüksekliği azalttım
                width: double.infinity,
                color: Colors.grey[800],
                child: const Icon(Icons.broken_image, color: Colors.white),
              ),
            ),
          ),
          Expanded( // Expanded widget'ı ekledim
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    movie.title,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Expanded( // Açıklama için Expanded
                    child: Text(
                      movie.description,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontSize: 10), // Font boyutunu küçülttüm
                      maxLines: 3, // Satır sayısını artırdım
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
