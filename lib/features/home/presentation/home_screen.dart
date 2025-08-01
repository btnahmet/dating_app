import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RefreshController _refreshController = RefreshController();
  final ScrollController _scrollController = ScrollController();

  List<int> movies = List.generate(5, (index) => index);
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        !isLoading) {
      _loadMore();
    }
  }

  void _loadMore() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      movies.addAll(List.generate(5, (index) => movies.length + index));
      isLoading = false;
    });
  }

  void _onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      movies = List.generate(5, (index) => index);
    });
    _refreshController.refreshCompleted();
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

    return SafeArea(
      child: Scaffold(
        body: SmartRefresher(
          controller: _refreshController,
          onRefresh: _onRefresh,
          enablePullDown: true,
          child: ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.06,
              vertical: height * 0.02,
            ),
            itemCount: movies.length + (isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == movies.length) {
                return Padding(
                  padding: EdgeInsets.all(height * 0.02),
                  child: const Center(child: CircularProgressIndicator()),
                );
              }
              return _MovieCard(index: movies[index]);
            },
          ),
        ),
      ),
    );
  }
}

class _MovieCard extends StatelessWidget {
  final int index;
  const _MovieCard({required this.index});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Card(
      color: const Color(0xFF1F1F1F),
      margin: EdgeInsets.only(bottom: height * 0.018),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(width * 0.045),
        child: Row(
          children: [
            Container(
              width: width * 0.2,
              height: height * 0.1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[800],
              ),
            ),
            SizedBox(width: width * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Movie Title $index',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: height * 0.005),
                  Text(
                    'Movie description goes here. Short and brief.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.favorite_border, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
