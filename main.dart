
import 'package:flutter/material.dart';

void main() {
  runApp(const HilwaFlixApp());
}

class Movie {
  final String title;
  final String image;
  final String category;
  final String description;

  const Movie({
    required this.title,
    required this.image,
    required this.category,
    required this.description,
  });
}

const List<Movie> movies = [
  Movie(
    title: 'Stranger Things',
    image: 'https://image.tmdb.org/t/p/w500/x2LSRK2Cm7MZhjluni1msVJ3wDF.jpg',
    category: 'Sci-Fi • Drama',
    description: 'Misteri dan petualangan di sebuah kota kecil.',
  ),
  Movie(
    title: 'Wednesday',
    image: 'https://image.tmdb.org/t/p/w500/9PFonBhy4cQy7Jz20NpMygczOkv.jpg',
    category: 'Mystery • Comedy',
    description: 'Misteri di sekolah yang penuh rahasia.',
  ),
  Movie(
    title: 'The Witcher',
    image: 'https://image.tmdb.org/t/p/w500/7vjaCdMw15FEbXyLQTVa04URsPm.jpg',
    category: 'Fantasy • Adventure',
    description: 'Petualangan pemburu monster.',
  ),
  Movie(
    title: 'Enola Holmes',
    image: 'https://image.tmdb.org/t/p/w500/riYInlsq2kf1AWoGm80JQW5dLKp.jpg',
    category: 'Adventure • Mystery',
    description: 'Detektif muda memecahkan sebuah misteri.',
  ),
  Movie(
    title: 'Red Notice',
    image: 'https://image.tmdb.org/t/p/w500/wdE6ewaKZHr62bLqCn7A2DiGShm.jpg',
    category: 'Action • Comedy',
    description: 'Aksi pencurian dengan berbagai kejutan.',
  ),
  Movie(
    title: 'Extraction',
    image: 'https://image.tmdb.org/t/p/w500/nygOUcBKPHFTbxsYRFZVePqgPK6.jpg',
    category: 'Action',
    description: 'Misi penyelamatan yang menegangkan.',
  ),
  Movie(
    title: 'The Gray Man',
    image: 'https://image.tmdb.org/t/p/w500/8cXbitsS6dWQ5gfMTZdorpAAzEH.jpg',
    category: 'Action • Thriller',
    description: 'Agen rahasia dalam perburuan berbahaya.',
  ),
  Movie(
    title: 'Enola Holmes 2',
    image: 'https://image.tmdb.org/t/p/w500/tegBpjM5ODoYoM1NjaiHVLEA0QM.jpg',
    category: 'Mystery',
    description: 'Kasus baru untuk detektif muda.',
  ),
];

class HilwaFlixApp extends StatelessWidget {
  const HilwaFlixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HilwaFlix',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF141414),
        colorScheme: const ColorScheme.dark(
          primary: Colors.red,
          surface: Color(0xFF141414),
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Set<String> myList = {};

  Movie get featuredMovie => movies[0];

  void toggleMyList(Movie movie) {
    final added = !myList.contains(movie.title);

    setState(() {
      if (added) {
        myList.add(movie.title);
      } else {
        myList.remove(movie.title);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          added
              ? '${movie.title} ditambahkan ke My List'
              : '${movie.title} dihapus dari My List',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: buildHeader()),
            SliverToBoxAdapter(child: buildHero()),
            SliverToBoxAdapter(
              child: MovieSection(
                title: 'Trending Now',
                movies: movies,
                myList: myList,
                onToggleMyList: toggleMyList,
              ),
            ),
            SliverToBoxAdapter(
              child: MovieSection(
                title: 'Popular on HilwaFlix',
                movies: movies.reversed.toList(),
                myList: myList,
                onToggleMyList: toggleMyList,
              ),
            ),
            if (myList.isNotEmpty)
              SliverToBoxAdapter(
                child: MovieSection(
                  title: 'My List',
                  movies: movies
                      .where((movie) => myList.contains(movie.title))
                      .toList(),
                  myList: myList,
                  onToggleMyList: toggleMyList,
                ),
              ),
            SliverToBoxAdapter(
              child: MovieSection(
                title: 'Action & Adventure',
                movies: movies
                    .where(
                      (movie) =>
                          movie.category.contains('Action') ||
                          movie.category.contains('Adventure'),
                    )
                    .toList(),
                myList: myList,
                onToggleMyList: toggleMyList,
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                  child: Text(
                    'HILWAFLIX',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 14,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.play_circle_fill,
            color: Colors.red,
            size: 34,
          ),
          const SizedBox(width: 7),
          const Text(
            'HILWAFLIX',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w900,
              fontSize: 21,
              letterSpacing: 1,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: MovieSearchDelegate(
                  movies: movies,
                  myList: myList,
                  onToggleMyList: toggleMyList,
                ),
              ).then((_) {
                if (mounted) setState(() {});
              });
            },
            icon: const Icon(Icons.search, size: 27),
          ),
          const SizedBox(width: 5),
          const CircleAvatar(
            radius: 17,
            backgroundColor: Colors.red,
            child: Icon(Icons.person, size: 21),
          ),
        ],
      ),
    );
  }

  Widget buildHero() {
    final isSaved = myList.contains(featuredMovie.title);

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 390,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                featuredMovie.image,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey.shade900,
                  child: const Icon(Icons.movie, size: 80),
                ),
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black12,
                      Colors.transparent,
                      Colors.black87,
                    ],
                    stops: [0, 0.35, 1],
                  ),
                ),
              ),
              Positioned(
                left: 20,
                right: 20,
                bottom: 22,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.local_fire_department,
                          color: Colors.red,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'PILIHAN HARI INI',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      featuredMovie.title,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      featuredMovie.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              showDialog<void>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(featuredMovie.title),
                                  content: const Text(
                                    'Fitur pemutaran video belum dihubungkan.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context),
                                      child: const Text('Tutup'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.play_arrow,
                              color: Colors.black,
                            ),
                            label: const Text(
                              'Play',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => toggleMyList(featuredMovie),
                            icon: Icon(
                              isSaved ? Icons.check : Icons.add,
                            ),
                            label: Text(
                              isSaved ? 'Added' : 'My List',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white24,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MovieSection extends StatelessWidget {
  final String title;
  final List<Movie> movies;
  final Set<String> myList;
  final ValueChanged<Movie> onToggleMyList;

  const MovieSection({
    super.key,
    required this.title,
    required this.movies,
    required this.myList,
    required this.onToggleMyList,
  });

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 190,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: movies.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final movie = movies[index];
                final isSaved = myList.contains(movie.title);

                return SizedBox(
                  width: 125,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => showDialog<void>(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: const Color(0xFF242424),
                        title: Text(movie.title),
                        content: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  movie.image,
                                  height: 180,
                                  width: 130,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.movie, size: 80),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(movie.category),
                              const SizedBox(height: 8),
                              Text(movie.description),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Tutup'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              onToggleMyList(movie);
                            },
                            child: Text(
                              isSaved ? 'Hapus dari My List' : 'My List +',
                            ),
                          ),
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  movie.image,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    color: Colors.grey.shade900,
                                    child: const Icon(
                                      Icons.movie,
                                      size: 40,
                                    ),
                                  ),
                                ),
                              ),
                              if (isSaved)
                                const Positioned(
                                  top: 5,
                                  right: 5,
                                  child: Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          movie.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MovieSearchDelegate extends SearchDelegate<Movie?> {
  final List<Movie> movies;
  final Set<String> myList;
  final ValueChanged<Movie> onToggleMyList;

  MovieSearchDelegate({
    required this.movies,
    required this.myList,
    required this.onToggleMyList,
  });

  @override
  String get searchFieldLabel => 'Cari film...';

  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(
          onPressed: () => query = '',
          icon: const Icon(Icons.clear),
        ),
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        onPressed: () => close(context, null),
        icon: const Icon(Icons.arrow_back),
      );

  @override
  Widget buildResults(BuildContext context) => buildMovieResults();

  @override
  Widget buildSuggestions(BuildContext context) => buildMovieResults();

  Widget buildMovieResults() {
    final results = movies
        .where(
          (movie) =>
              movie.title.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final movie = results[index];

        return ListTile(
          leading: Image.network(
            movie.image,
            width: 45,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.movie),
          ),
          title: Text(movie.title),
          subtitle: Text(movie.category),
          trailing: IconButton(
            icon: Icon(
              myList.contains(movie.title)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: () => onToggleMyList(movie),
          ),
        );
      },
    );
  }
}
