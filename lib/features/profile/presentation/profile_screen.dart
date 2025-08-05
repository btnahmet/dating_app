import 'package:dating_app/widgets/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:dating_app/l10n/app_localizations.dart';
import '../../home/viewmodel/home_view_model.dart';
import '../../home/model/movie_model.dart';
import '../../premium/presentation/widgets/limited_offer_bottom_sheet.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/token_storage_service.dart';
import '../../../core/services/logger_service.dart';
import 'dart:convert';
import 'package:lottie/lottie.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _apiService = ApiService();
  final _tokenStorage = TokenStorageService();
  bool _isLoggingOut = false;
  String _userName = 'Kullanıcı';
  String _userPhotoUrl = '';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    Future.microtask(() {
      if (mounted) {
        final viewModel = Provider.of<HomeViewModel>(context, listen: false);
        viewModel.loadFavoriteMovies();
      }
    });
  }

  Future<void> _loadUserInfo() async {
    try {
      final token = await _tokenStorage.getToken();
      if (token != null) {
        final parts = token.split('.');
        if (parts.length == 3) {
          final payload = parts[1];
          final normalized = base64Url.normalize(payload);
          final resp = utf8.decode(base64Url.decode(normalized));
          final payloadMap = json.decode(resp);

          setState(() {
            _userName = payloadMap['name'] ?? 'Kullanıcı';
            _userPhotoUrl = payloadMap['photoUrl'] ?? '';
          });
        }
      }
    } catch (e) {
      LoggerService.error('Kullanıcı bilgileri yüklenirken hata: $e');
    }
  }

  void _showLimitedOffer() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const LimitedOfferBottomSheet(),
    );
  }

  void _navigateToUploadPhoto() {
    context.push('/upload-photo');
  }

  Future<void> _logout() async {
    setState(() {
      _isLoggingOut = true;
    });

    try {
      await _apiService.logout();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.logoutSuccess)),
        );
        context.go('/login');
      }
    } catch (e) {
      LoggerService.error('Logout hatası: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text("${AppLocalizations.of(context)!.logoutFailed}: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoggingOut = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.03),
              Row(
                children: [
                  CircleAvatar(
                    radius: width * 0.06,
                    backgroundColor: const Color(0xFF1F1F1F),
                    child: IconButton(
                      icon: _isLoggingOut
                          ? SizedBox(
                              width: width * 0.05,
                              height: width * 0.05,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Icon(Icons.arrow_back, color: Colors.white, size: width * 0.06),
                      onPressed: _isLoggingOut ? null : _logout,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    l10n.profileDetails,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(width * 0.06),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _showLimitedOffer,
                        borderRadius: BorderRadius.circular(width * 0.06),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 0.04, vertical: height * 0.01),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(LucideIcons.gem,
                                  size: width * 0.04, color: Colors.white),
                              SizedBox(width: width * 0.015),
                              Flexible(
                                child: Text(l10n.limitedOffer,
                                    style: const TextStyle(color: Colors.white),
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.03),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: width * 0.09,
                    backgroundColor:
                        _userPhotoUrl.isEmpty ? const Color(0xFF1F1F1F) : null,
                    backgroundImage: _userPhotoUrl.isNotEmpty
                        ? NetworkImage(_userPhotoUrl)
                        : null,
                    child: _userPhotoUrl.isEmpty
                        ? Icon(Icons.person,
                            color: Colors.white, size: width * 0.09)
                        : null,
                  ),
                  SizedBox(width: width * 0.04),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _userName,
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
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _navigateToUploadPhoto,
                        borderRadius: BorderRadius.circular(24),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Text(l10n.addPhoto,
                              style: const TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.favoriteMovies,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.language,
                        color: Colors.white, size: 20),
                    onSelected: (value) {
                      if (value == 'tr') {
                        context
                            .read<LocaleProvider>()
                            .setLocale(const Locale('tr'));
                      } else if (value == 'en') {
                        context
                            .read<LocaleProvider>()
                            .setLocale(const Locale('en'));
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'tr', child: Text('Türkçe')),
                      const PopupMenuItem(value: 'en', child: Text('English')),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Consumer<HomeViewModel>(
                  builder: (context, viewModel, child) {
                    if (viewModel.isLoadingFavorites) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // if (viewModel.favoriteMovies.isEmpty) {
                    //   return Center(
                    //     child: Text(
                    //       l10n.noFavoriteMovies,
                    //       style: const TextStyle(color: Colors.white70),
                    //     ),
                    //   );
                    // }
                    if (viewModel.favoriteMovies.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset(
                              'assets/animations/movieAnimation.json',
                              width: 200,
                              height: 200,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              l10n.noFavoriteMovies,
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      );
                    }

                    return GridView.builder(
                      itemCount: viewModel.favoriteMovies.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        mainAxisExtent: 200,
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
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Image.network(
              movie.posterUrl,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 120,
                width: double.infinity,
                color: Colors.grey[800],
                child: const Icon(Icons.broken_image, color: Colors.white),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  const SizedBox(height: 4),
                  Expanded(
                    child: Text(
                      movie.description,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontSize: 10),
                      maxLines: 3,
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
