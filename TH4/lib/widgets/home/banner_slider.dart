import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class BannerSlider extends StatefulWidget {
  const BannerSlider({super.key});

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  int _current = 0;
  final List<String> imgList = [
    'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?q=80&w=1000',
    'https://images.unsplash.com/photo-1544441893-675973e31985?q=80&w=1000',
    'https://images.unsplash.com/photo-1441986300917-64674bd600d8?q=80&w=1000',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items: imgList.map((item) => Container(
            margin: const EdgeInsets.all(5.0),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              child: Image.network(item, fit: BoxFit.cover, width: 1000),
            ),
          )).toList(),
          options: CarouselOptions(
            autoPlay: true,
            aspectRatio: 2.0,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imgList.asMap().entries.map((entry) {
            return Container(
              width: 8.0,
              height: 8.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.blue)
                    .withValues(alpha: _current == entry.key ? 0.9 : 0.4),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
