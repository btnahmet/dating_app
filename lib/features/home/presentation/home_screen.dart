import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../model/movie_model.dart';
import '../viewmodel/home_view_model.dart';
import '../../../core/services/token_storage_service.dart';
import 'package:lottie/lottie.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RefreshController _refreshController = RefreshController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    print('HomeScreen: initState çağrıldı');
    Future.microtask(() {
      final viewModel = Provider.of<HomeViewModel>(context, listen: false);
      print('HomeScreen: Film yükleme başlatılıyor');
      viewModel.loadMovies();
      // Beğenilen filmleri de yükle
      viewModel.loadFavoriteMovies();
    });

    _scrollController.addListener(() {
      final viewModel = Provider.of<HomeViewModel>(context, listen: false);
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100 &&
          !viewModel.isLoading) {
        viewModel.loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final viewModel = Provider.of<HomeViewModel>(context);

    print(
        'HomeScreen: build çağrıldı - Film sayısı: ${viewModel.movies.length}, Loading: ${viewModel.isLoading}');

    return SafeArea(
      child: Scaffold(
        body: SmartRefresher(
          controller: _refreshController,
          onRefresh: () async {
            await viewModel.refreshMovies();
            _refreshController.refreshCompleted();
          },
          enablePullDown: true,
          child: viewModel.isLoading && viewModel.movies.isEmpty
              ? const Center(child: CircularProgressIndicator())
              // : viewModel.movies.isEmpty
              //     ? const Center(
              //         child: Text(
              //           'Film bulunamadı',
              //           style: TextStyle(color: Colors.white),
              //         ),
              //       )
              : viewModel.movies.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Lottie.asset(
                            'assets/animations/noData.json',
                            width: 220,
                            height: 220,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Film bulunamadı',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.06,
                        vertical: height * 0.02,
                      ),
                      itemCount: viewModel.movies.length +
                          (viewModel.isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == viewModel.movies.length) {
                          return Padding(
                            padding: EdgeInsets.all(height * 0.02),
                            child: const Center(
                                child: CircularProgressIndicator()),
                          );
                        }
                        return _MovieCard(movie: viewModel.movies[index]);
                      },
                    ),
        ),
      ),
    );
  }
}

class _MovieCard extends StatelessWidget {
  final MovieModel movie;
  const _MovieCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final viewModel = Provider.of<HomeViewModel>(context);

    return Card(
      color: const Color(0xFF1F1F1F),
      margin: EdgeInsets.only(bottom: height * 0.018),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(width * 0.045),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                movie.posterUrl,
                width: width * 0.2,
                height: height * 0.1,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: width * 0.2,
                  height: height * 0.1,
                  color: Colors.grey[800],
                  child: const Icon(Icons.broken_image, color: Colors.white),
                ),
              ),
            ),
            SizedBox(width: width * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: height * 0.005),
                  Text(
                    movie.description,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                viewModel.isFavorite(movie.id)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color:
                    viewModel.isFavorite(movie.id) ? Colors.red : Colors.white,
              ),
              onPressed: () async {
                print(
                    'HomeScreen: Beğeni butonuna tıklandı - Movie ID: ${movie.id}');
                print('HomeScreen: Film başlığı: ${movie.title}');
                print(
                    'HomeScreen: Şu anki beğeni durumu: ${viewModel.isFavorite(movie.id)}');

                // Token kontrolü
                final tokenStorage = TokenStorageService();
                final token = await tokenStorage.getToken();

                if (token == null) {
                  print(
                      'HomeScreen: Token bulunamadı, kullanıcı giriş yapmamış');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Film beğenmek için önce giriş yapmalısınız'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                print('HomeScreen: Token mevcut, beğeni işlemi başlatılıyor');
                viewModel.toggleFavorite(movie.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
