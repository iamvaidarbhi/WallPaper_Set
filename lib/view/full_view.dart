import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:cache_manager/cache_manager.dart';

class FullView extends StatefulWidget {
  final String imageURL;

  const FullView({Key? key, required this.imageURL}) : super(key: key);

  @override
  _FullViewState createState() => _FullViewState();
}

class _FullViewState extends State<FullView> {
  Future<void> setWallpaper() async {
    try {
      String url = widget.imageURL;
      int location = WallpaperManager
          .BOTH_SCREEN;
      var file = await DefaultCacheManager().getSingleFile(url);
      final bool result =
          await WallpaperManager.setWallpaperFromFile(file.path, location);
      print(result);
    } on PlatformException {
    print("Error Log");
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: Image.network(
                widget.imageURL,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            height: 60,
            width: double.infinity,
            child: InkWell(
              onTap: () {
                setWallpaper();
                //    loadMore();
              },
              child: Center(
                child: Text(
                  "Set WallPaper",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
