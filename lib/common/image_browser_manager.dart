import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageBrowserManager {
  static void showImageBrowser({
    required List imgList,
    int index = 0,
    BuildContext? context, //用 getX框架可不传
    GestureTapCallback? onLongPress,
  }) {
    Navigator.of(context ?? Get.context!).push(PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black,
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
              opacity: animation,
              child: ImageBrowser(
                imgList: imgList,
                index: index,
                onLongPress: onLongPress,
              ));
        }));
  }
}

class ImageBrowser extends StatefulWidget {
  final List imgList;
  final int index;
  final GestureTapCallback? onLongPress;

  const ImageBrowser({
    super.key,
    required this.imgList,
    required this.index,
    this.onLongPress,
  });

  @override
  State<ImageBrowser> createState() => _ImageBrowserState();
}

class _ImageBrowserState extends State<ImageBrowser> {
  int _currentIndex = 0;
  PageController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: widget.index);
    setState(() {
      _currentIndex = widget.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text('${_currentIndex + 1}/${widget.imgList.length}'),
        backgroundColor: Colors.black,
        leading: const SizedBox(),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, size: 30, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      // bottomNavigationBar: Container(
      //   padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      //   color: Colors.black,
      //   child: SizedBox(
      //     height: 50,
      //     child: IconButton(
      //       icon: const Icon(Icons.download_rounded,
      //           size: 30, color: Colors.white),
      //       onPressed: () {
      //         // CommonUtil.saveToAlbum([widget.imgList[_currentIndex]]);
      //       },
      //     ),
      //   ),
      // ),
      body: Center(
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          onLongPress: widget.onLongPress,
          child: Container(
            color: Colors.black,
            child: PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: (BuildContext context, int index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider:
                      (widget.imgList[index] as String).contains("http")
                          ? NetworkImage(widget.imgList[index])
                          : AssetImage(widget.imgList[index]),
                );
              },
              itemCount: widget.imgList.length,
              backgroundDecoration: null,
              pageController: _controller,
              enableRotation: true,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
