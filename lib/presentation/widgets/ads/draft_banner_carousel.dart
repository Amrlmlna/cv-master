import 'dart:async';
import 'package:flutter/material.dart';

class DraftsBannerCarousel extends StatefulWidget {
  const DraftsBannerCarousel({super.key});

  @override
  State<DraftsBannerCarousel> createState() => _DraftsBannerCarouselState();
}

class _DraftsBannerCarouselState extends State<DraftsBannerCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<Map<String, String>> _bannerData = [
    {
      'title': 'Go Premium',
      'subtitle': 'Remove all ads and unlock exclusive templates.',
      'tag': 'AD',
    },
    {
      'title': 'Get Noticed Faster',
      'subtitle': 'AI-optimized CVs get 3x more interviews.',
      'tag': 'PRO',
    },
    {
      'title': 'Unlimited Downloads',
      'subtitle': 'Export as many versions as you need in PDF.',
      'tag': 'FREE',
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage < _bannerData.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 140, // Slightly smaller than AI banner
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemCount: _bannerData.length,
            itemBuilder: (context, index) {
              return _buildBannerCard(
                title: _bannerData[index]['title']!,
                subtitle: _bannerData[index]['subtitle']!,
                tag: _bannerData[index]['tag']!,
                color: index % 2 == 0 ? const Color(0xFF2C3E50) : const Color(0xFF34495E),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _bannerData.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 6,
              width: _currentPage == index ? 20 : 6,
              decoration: BoxDecoration(
                color: _currentPage == index ? const Color(0xFF2C3E50) : Colors.grey[300],
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBannerCard({required String title, required String subtitle, required String tag, required Color color}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          // const SizedBox(width: 8),
          // Icon(Icons.star_border, color: Colors.white.withOpacity(0.2), size: 48),
        ],
      ),
    );
  }
}
