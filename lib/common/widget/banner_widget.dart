// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// ///封装的艺术之轮播图组件的实现
// class BannerWidget extends StatefulWidget {
//   // final List<CommonModel> bannerList;
//   final List<String> imagesList;
//   const BannerWidget({Key? key, required this.imagesList}) : super(key: key);
//
//   @override
//   State<BannerWidget> createState() => _BannerWidgetState();
// }
//
// class _BannerWidgetState extends State<BannerWidget> {
//   int _current = 0;
//   final CarouselSliderController _controller = CarouselSliderController();
//
//   @override
//   Widget build(BuildContext context) {
//     final double width = MediaQuery.of(context).size.width;
//     return Stack(
//       children: [
//         CarouselSlider(
//           items:
//               widget.imagesList.map((item) => _tabImage(item, width)).toList(),
//           carouselController: _controller,
//           options: CarouselOptions(
//               height: 160.h,
//               autoPlay: true,
//               viewportFraction: 1.0,
//               onPageChanged: (index, reason) {
//                 setState(() {
//                   _current = index;
//                 });
//               }),
//         ),
//         Positioned(bottom: 10, left: 0, right: 0, child: _indicator())
//       ],
//     );
//   }
//
//   Widget _tabImage(String image, double width) {
//     return GestureDetector(
//       onTap: () {
//         // NavigatorUtil.jumpH5(
//         //     url: model.url, title: model.title, hideAppBar: model.hideAppBar);
//       },
//       child: Image.network(
//         image,
//         width: width,
//         fit: BoxFit.cover,
//       ),
//     );
//   }
//
//   _indicator() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: widget.imagesList.asMap().entries.map((entry) {
//         return GestureDetector(
//           onTap: () => _controller.animateToPage(entry.key),
//           child: Container(
//             width: 6,
//             height: 6,
//             margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color:
//                   (Colors.white).withOpacity(_current == entry.key ? 0.9 : 0.4),
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }
// }
