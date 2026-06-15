import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class NoticeSlideshow extends StatelessWidget {
  final List<String> notices = [
    "3:00 PM: Server maintenance on Sunday",
    "4:30 PM: New feature released",
    "5:00 PM: Update your app now",
  ];

  // _buildTaskPreview(
  //             '3:00 PM',
  //             'Design review',
  //             'Set a calm pace for your afternoon sprint.',
  //           ),
  //           const SizedBox(height: 12),
  //           _buildTaskPreview(
  //             '4:30 PM',
  //             'Goals refresh',
  //             'Update milestones and note progress.',
  //           ),

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CarouselSlider.builder(
        itemCount: notices.length,
        options: CarouselOptions(
          height: 80.0,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 3),
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          viewportFraction: 0.9,
          enlargeCenterPage: true,
        ),
        itemBuilder: (context, index, realIdx) {
          return Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 5.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              // color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                notices[index],
                style: TextStyle(color: Colors.black54, fontSize: 14.0),
              ),
            ),
          );
        },
      ),
    );
  }
}
