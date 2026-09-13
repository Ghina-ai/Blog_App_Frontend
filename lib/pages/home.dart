import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class HomePage extends StatefulWidget {
  final String nama;

  const HomePage({
    super.key,
    required this.nama,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  // =========================
  // DATA DUMMY ARTIKEL
  // =========================
  final List<Map<String, dynamic>> articles = [
    {
      "category": "Technology",
      "title": "Building a Successful Design System",
      "author": "Sourav Mahmud",
      "time": "2 days ago",
      "read": "5 min read",
      "image":
          "https://images.unsplash.com/photo-1558655146-d09347e92766?w=800",
    },
    {
      "category": "Lifestyle",
      "title": "Visiting towards the nature all alone",
      "author": "Dale Philip",
      "time": "5 days ago",
      "read": "4 min read",
      "image":
          "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800",
    },
    {
      "category": "Technology",
      "title": "The Curious Case of Instagram Comments",
      "author": "LIX Ninja",
      "time": "Nov 20, 2022",
      "read": "8 min read",
      "image":
          "https://images.unsplash.com/photo-1611162617474-5b21e879e113?w=800",
    },
    {
      "category": "Food",
      "title": "Exploring delicious food around us",
      "author": "Nana",
      "time": "1 day ago",
      "read": "6 min read",
      "image":
          "https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800",
    },
  ];

  final List<String> categories = [
    "For You",
    "Popular",
    "Trending",
    "Following",
    "Categories",
  ];

  // =========================
  // HOME PAGE
  // =========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7F8),

      body: SafeArea(
        child: Column(
          children: [
            // =========================
            // CONTENT
            // =========================
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const SizedBox(height: 10),

                      // =========================
                      // TOP BAR
                      // =========================
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.menu,
                              size: 25,
                              color: Color(0xff263238),
                            ),
                          ),

                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xff1D4055),
                                width: 2,
                              ),
                              image: const DecorationImage(
                                image: NetworkImage(
                                  "https://i.pravatar.cc/150?img=47",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 5),

                      // =========================
                      // GREETING
                      // =========================
                      Text(
                        "Hi, Good Day!",
                        style: GoogleFonts.poppins(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xff17202A),
                        ),
                      ),

                      Text(
                        "What do you want to read today?",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),

                      const SizedBox(height: 18),

                      // =========================
                      // CONTINUE READING
                      // =========================
                      _continueReading(),

                      const SizedBox(height: 22),

                      // =========================
                      // CATEGORY TAB
                      // =========================
                      SizedBox(
                        height: 38,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final isActive = index == 0;

                            return Container(
                              margin: const EdgeInsets.only(right: 25),
                              child: Column(
                                children: [
                                  Text(
                                    categories[index],
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      fontWeight: isActive
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                      color: isActive
                                          ? const Color(0xff1D4055)
                                          : Colors.grey.shade500,
                                    ),
                                  ),

                                  const SizedBox(height: 7),

                                  if (isActive)
                                    Container(
                                      width: 45,
                                      height: 2,
                                      decoration: BoxDecoration(
                                        color: const Color(0xff1D4055),
                                        borderRadius:
                                            BorderRadius.circular(10),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 18),

                      // =========================
                      // ARTICLE LIST
                      // =========================
                      ListView.builder(
                        itemCount: articles.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return _articleCard(
                            articles[index],
                          );
                        },
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // =========================
      // BOTTOM NAVIGATION
      // =========================
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25),
          ),
        ),
        child: SalomonBottomBar(
          currentIndex: _currentIndex,

          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },

          selectedItemColor: const Color(0xff1D4055),

          items: [
            SalomonBottomBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home),
              title: const Text("Home"),
              selectedColor: const Color(0xff1D4055),
            ),

            SalomonBottomBarItem(
              icon: const Icon(Icons.search),
              title: const Text("Search"),
              selectedColor: const Color(0xff1D4055),
            ),

            SalomonBottomBarItem(
              icon: const Icon(Icons.bookmark_border),
              activeIcon: const Icon(Icons.bookmark),
              title: const Text("Favorite"),
              selectedColor: const Color(0xff1D4055),
            ),

            SalomonBottomBarItem(
              icon: const Icon(Icons.person_outline),
              activeIcon: const Icon(Icons.person),
              title: const Text("Account"),
              selectedColor: const Color(0xff1D4055),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // CONTINUE READING CARD
  // =====================================================

  Widget _continueReading() {
    return Container(
      height: 110,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xffE5EEF0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              "https://images.unsplash.com/photo-1499750310107-5fef28a66643?w=500",
              width: 105,
              height: 110,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Continue Reading?",
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    "Creating effective\nprototype that works",
                    maxLines: 2,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      height: 1.15,
                    ),
                  ),

                  const Spacer(),

                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 3,
                          decoration: BoxDecoration(
                            color: const Color(0xff1D4055),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Text(
                        "2 min left",
                        style: GoogleFonts.poppins(
                          fontSize: 8,
                          color: Colors.grey.shade600,
                        ),
                      ),

                      const SizedBox(width: 10),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(
              right: 8,
              top: 7,
            ),
            child: Align(
              alignment: Alignment.topRight,
              child: Icon(
                Icons.close,
                size: 16,
                color: Colors.grey.shade500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // ARTICLE CARD
  // =====================================================

  Widget _articleCard(Map<String, dynamic> article) {
    return Container(
      margin: const EdgeInsets.only(bottom: 17),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // =========================
          // IMAGE
          // =========================
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              article["image"],
              width: 82,
              height: 82,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 82,
                  height: 82,
                  color: Colors.grey.shade300,
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          ),

          const SizedBox(width: 12),

          // =========================
          // ARTICLE INFORMATION
          // =========================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // CATEGORY
                Text(
                  article["category"],
                  style: GoogleFonts.poppins(
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff555555),
                  ),
                ),

                const SizedBox(height: 2),

                // TITLE
                Text(
                  article["title"],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    height: 1.15,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff202124),
                  ),
                ),

                const SizedBox(height: 5),

                // AUTHOR + TIME
                Row(
                  children: [
                    Container(
                      width: 19,
                      height: 19,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(
                            "https://i.pravatar.cc/100?img=12",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    const SizedBox(width: 5),

                    Expanded(
                      child: Text(
                        "${article["author"]} • ${article["time"]} • ${article["read"]}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 8,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // =========================
          // MORE + BOOKMARK
          // =========================
          Column(
            children: [
              const Icon(
                Icons.more_vert,
                size: 19,
                color: Color(0xff333333),
              ),

              const SizedBox(height: 28),

              const Icon(
                Icons.bookmark_border,
                size: 20,
                color: Color(0xff1D4055),
              ),
            ],
          ),
        ],
      ),
    );
  }
}