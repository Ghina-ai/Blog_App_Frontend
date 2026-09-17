import 'package:flutter/material.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';

import 'pages/splashScreen.dart';
import 'pages/login.dart';
import 'pages/regis.dart';
import 'pages/home.dart';
import 'pages/sreach.dart';
import 'pages/detail.dart';
import 'pages/profile.dart';
import 'pages/tambahData.dart';

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

      // LAYAR PERTAMA SAAT APLIKASI DIBUKA
      initialRoute: '/opening',

      routes: {
        '/opening': (context) => const OpeningPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const MainPage(),
      },
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final PageController pageController = PageController(
    initialPage: 0,
  );

  final NotchBottomBarController controller =
      NotchBottomBarController(
    index: 0,
  );

  int currentIndex = 0;

  final GlobalKey<HomePageState> homeKey =
      GlobalKey<HomePageState>();

  // Setelah posting selesai → refresh Home → kembali ke Home
  Future<void> finishWrite() async {
    await homeKey.currentState?.loadPosts();

    if (!mounted) return;

    setState(() {
      currentIndex = 0;
    });

    controller.jumpTo(0);
    pageController.jumpToPage(0);
  }

  // Pindah halaman dari bottom navigation
  void goToPage(int index) {
    setState(() {
      currentIndex = index;
    });

    controller.jumpTo(index);
    pageController.jumpToPage(index);
  }

  // Tombol Write dari Home
  void openWritePage() {
    setState(() {
      currentIndex = 2;
    });

    controller.jumpTo(2);
    pageController.jumpToPage(2);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,

        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });

          controller.jumpTo(index);
        },

        children: [
          HomePage(
            key: homeKey,
            onSearchTap: () {
              goToPage(1);
            },
            onWriteTap: openWritePage,
          ),

          const SearchPage(),

          WritePage(
            onPostCreated: finishWrite,
          ),

          const ProfilePage(),
        ],
      ),

      extendBody: true,

      // ===============================
      // BOTTOM NAVIGATION
      // ===============================
      bottomNavigationBar: AnimatedNotchBottomBar(
        notchBottomBarController: controller,

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
              Icons.add,
              color: Colors.grey,
            ),
            activeItem: Icon(
              Icons.add,
              color: Colors.blue,
            ),
            itemLabel: 'Write',
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
          goToPage(index);
        },
      ),
    );
  }
}

// ===============================
// HALAMAN LAIN
// ===============================

class BookmarkPage extends StatelessWidget {
  const BookmarkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Bookmark'),
    );
  }
}