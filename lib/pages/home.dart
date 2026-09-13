import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =========================
              // HEADER
              // =========================

              const SizedBox(height: 18),

              Row(
                children: [
                  // LOGO
                  Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'assets/logo.png',
                            width: 10,
                            height: 10,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      const Text(
                        "Blog",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF252B35),
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // SEARCH
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.search,
                      size: 21,
                      color: Color(0xFF4D5664),
                    ),
                  ),

                  const SizedBox(width: 10),
                ],
              ),

              const SizedBox(height: 25),

              // =========================
              // GREETING
              // =========================

              const Text(
                "Hi, Good Day! 👋",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF202631),
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                "Buatlah artikel untukmu sebanyak mungkin",
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF7B8491),
                ),
              ),

              const SizedBox(height: 22),

              // =========================
              // FEATURED ARTICLE
              // =========================

              Container(
                height: 225,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  image: const DecorationImage(
                    image: NetworkImage(
                      "https://images.unsplash.com/photo-1518770660439-4636190af475",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Color(0xE6000000),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          "Technology",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2477D4),
                          ),
                        ),
                      ),

                      const SizedBox(height: 9),

                      const Text(
                        "Perkembangan Teknologi yang Mengubah Kehidupan Kita",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            color: Colors.white70,
                            size: 14,
                          ),

                          SizedBox(width: 4),

                          Text(
                            "Ghinaa",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                            ),
                          ),

                          SizedBox(width: 12),

                          Icon(
                            Icons.access_time,
                            color: Colors.white70,
                            size: 13,
                          ),

                          SizedBox(width: 4),

                          Text(
                            "5 min read",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // =========================
              // ARTICLES
              // =========================

              Row(
                children: [
                  Expanded(
                    child: _articleCard(
                      image:
                          "https://images.unsplash.com/photo-1531482615713-2afd69097998",
                      category: "Education",
                      title: "Cara Belajar Lebih Efektif di Era Digital",
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: _articleCard(
                      image:
                          "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee",
                      category: "Lifestyle",
                      title: "Menjaga Keseimbangan Hidup di Tengah Kesibukan",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // =========================
              // FOR YOU
              // =========================

              const Text(
                "For You",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF252B35),
                ),
              ),

              const SizedBox(height: 12),

              // CARD 1
              _forYouCard(
                image:
                    "https://images.unsplash.com/photo-1498050108023-c5249f4df085",
                category: "TECHNOLOGY",
                title: "Teknologi yang Mengubah Kehidupan Kita",
                author: "Ghinaa",
                date: "12 Jun 2026",
              ),

              // CARD 2
              _forYouCard(
                image:
                    "https://images.unsplash.com/photo-1531482615713-2afd69097998",
                category: "EDUCATION",
                title: "Cara Belajar Lebih Efektif di Era Digital",
                author: "Ghinaa",
                date: "10 Jun 2026",
              ),

              // CARD 3
              _forYouCard(
                image:
                    "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee",
                category: "LIFESTYLE",
                title: "Menjaga Keseimbangan Hidup di Tengah Kesibukan",
                author: "Ghinaa",
                date: "8 Jun 2026",
              ),

              // CARD 4
              _forYouCard(
                image:
                    "https://images.unsplash.com/photo-1516321318423-f06f85e504b3",
                category: "TECHNOLOGY",
                title: "Tips Menggunakan Teknologi dengan Bijak",
                author: "Ghinaa",
                date: "6 Jun 2026",
              ),

              // CARD 5
              _forYouCard(
                image:
                    "https://images.unsplash.com/photo-1522202176988-66273c2fd55f",
                category: "EDUCATION",
                title: "Membangun Kebiasaan Belajar yang Baik",
                author: "Ghinaa",
                date: "4 Jun 2026",
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // =========================
  // CATEGORY BUTTON
  // =========================

  Widget _categoryButton(String title, bool active) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: active ? const Color(0xFF2477D4) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: active
              ? const Color(0xFF2477D4)
              : const Color(0xFFE2E6EB),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: active
              ? Colors.white
              : const Color(0xFF697381),
        ),
      ),
    );
  }

  // =========================
  // ARTICLE CARD LAMA
  // =========================

  Widget _articleCard({
    required String image,
    required String category,
    required String title,
  }) {
    return Container(
      height: 225,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        image: DecorationImage(
          image: NetworkImage(image),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Color(0xE6000000),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 7,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                category,
                style: const TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2477D4),
                ),
              ),
            ),

            const SizedBox(height: 7),

            Text(
              title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),

            const SizedBox(height: 7),

            const Text(
              "5 min read",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 9,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // FOR YOU CARD BARU
  // =========================

  Widget _forYouCard({
    required String image,
    required String category,
    required String title,
    required String author,
    required String date,
  }) {
    return Container(
      height: 120,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // IMAGE
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(14),
              bottomLeft: Radius.circular(14),
            ),
            child: Image.network(
              image,
              width: 105,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 14),

          // CONTENT
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 13,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // CATEGORY
                  Text(
                    category,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF9AA1AB),
                      letterSpacing: 0.5,
                    ),
                  ),

                  const SizedBox(height: 5),

                  // TITLE
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF252B35),
                      height: 1.2,
                    ),
                  ),

                  const Spacer(),

                  // AUTHOR + DATE
                  Row(
                    children: [
                      const Icon(
                        Icons.person_outline,
                        size: 13,
                        color: Color(0xFF8D96A3),
                      ),

                      const SizedBox(width: 4),

                      Text(
                        author,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF8D96A3),
                        ),
                      ),

                      const SizedBox(width: 10),

                      const Text(
                        "•",
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFFC5CAD1),
                        ),
                      ),

                      const SizedBox(width: 7),

                      Text(
                        date,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF8D96A3),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 12),
        ],
      ),
    );
  }

  // =========================
  // BOTTOM ICON
  // =========================

  Widget _bottomIcon(IconData icon, bool active) {
    return Icon(
      icon,
      size: 25,
      color: active
          ? const Color(0xFF2477D4)
          : const Color(0xFF9AA1AB),
    );
  }
}