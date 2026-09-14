import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/core/utils/dummy_data.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'feature/feed/presentation/views/home_screen.dart';
import 'feature/message/presentation/views/messages_screen.dart';
import 'feature/profile/presentation/views/profile_screen.dart';
import 'feature/reels/presentation/views/reels_screen.dart';
import 'feature/search/presentation/views/search_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _page = 0;
  late PageController pageController;

  final user = DummyData.currentUser;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
        children: [
          HomeScreen(),
          ReelsScreen(),
          MessagesScreen(),
          SearchScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
        ),
        child: BottomNavigationBar(
          onTap: navigationTapped,
          backgroundColor: Colors.black,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          currentIndex: _page,
          enableFeedback: false,
          landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
          items: [
            BottomNavigationBarItem(
              icon: BottomNavImageIcon(
                imgPath: 'assets/icons/home.png',
                isSelected: _page == 0,
                size: 20,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: BottomNavImageIcon(
                imgPath: 'assets/icons/video.png',
                isSelected: _page == 1,
              ),
              label: 'Reels',
            ),
            BottomNavigationBarItem(
              icon: BottomNavImageIcon(
                imgPath: 'assets/icons/message_icon.png',
                isSelected: _page == 2,
              ),
              label: 'Messages',
            ),
            BottomNavigationBarItem(
              icon: BottomNavImageIcon(
                imgPath: 'assets/icons/search_icon.png',
                isSelected: _page == 3,
              ),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                width: 28.w,
                height: 28.h,
                padding: _page == 4 ? const EdgeInsets.all(2) : EdgeInsets.zero,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: _page == 4
                      ? Border.all(color: Colors.white, width: 1.5)
                      : Border.all(color: Colors.transparent, width: 1.5),
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: user['profilePic'] as String,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Container(color: Colors.grey.shade800),
                    errorWidget: (context, url, error) =>
                        Icon(Icons.person, size: 20),
                  ),
                ),
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNavImageIcon extends StatelessWidget {
  final String imgPath;
  final bool isSelected;
  final double size;

  const BottomNavImageIcon({
    super.key,
    required this.imgPath,
    required this.isSelected,
    this.size = 22,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isSelected ? 1.08 : 1.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      child: AnimatedOpacity(
        opacity: isSelected ? 1.0 : 0.6,
        duration: const Duration(milliseconds: 200),
        child: SizedBox(
          width: 22.w,
          height: 22.h,
          child: Center(
            child: Image.asset(
              imgPath,
              width: size.w,
              height: size.h,
              fit: BoxFit.contain,
              color: isSelected ? Colors.white : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
