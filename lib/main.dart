import 'package:flutter/material.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';

import 'pages/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blog App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final PageController _pageController = PageController(initialPage: 0);

  final NotchBottomBarController _controller =
      NotchBottomBarController(index: 0);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          HomePage(),
          SearchPage(),
          BookmarkPage(),
          ProfilePage(),
        ],
      ),

      extendBody: true,

      bottomNavigationBar: AnimatedNotchBottomBar(
        notchBottomBarController: _controller,
        
        kIconSize: 24,
        kBottomRadius: 28,
        color: Colors.white,
        notchColor: Colors.white,
        showLabel: false,
        showShadow: true,

        bottomBarItems: const [
          BottomBarItem(
            inActiveItem: Icon(
              Icons.home_outlined,
              color: Colors.grey,
            ),
            activeItem: Icon(
              Icons.home,
              color: Colors.blue,
            ),
            itemLabel: 'Home',
          ),

          BottomBarItem(
            inActiveItem: Icon(
              Icons.search,
              color: Colors.grey,
            ),
            activeItem: Icon(
              Icons.search,
              color: Colors.blue,
            ),
            itemLabel: 'Search',
          ),

          BottomBarItem(
            inActiveItem: Icon(
              Icons.bookmark_border,
              color: Colors.grey,
            ),
            activeItem: Icon(
              Icons.bookmark,
              color: Colors.blue,
            ),
            itemLabel: 'Bookmark',
          ),

          BottomBarItem(
            inActiveItem: Icon(
              Icons.person_outline,
              color: Colors.grey,
            ),
            activeItem: Icon(
              Icons.person,
              color: Colors.blue,
            ),
            itemLabel: 'Profile',
          ),
        ],

        onTap: (index) {
          _pageController.jumpToPage(index);
        },
      ),
    );
  }
}


// ===============================
// HALAMAN LAIN
// ===============================

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Search'),
    );
  }
}


class BookmarkPage extends StatelessWidget {
  const BookmarkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Bookmark'),
    );
  }
}


class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Profile'),
    );
  }
}