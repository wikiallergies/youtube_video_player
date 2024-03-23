import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import '../../const/colors/colors.dart';
import 'landscape_controller.dart';
import 'landscape_video.dart';
import 'video_player_controller.dart';

// ignore: must_be_immutable
class LandscapePlayer extends StatelessWidget {
  final Color? kColorWhite;
  final Color? kColorPrimary;
  final Color? kColorBlack;
  final VideoPlayerSreenController videoPlayerSreenController;

  LandscapePlayer(
      {Key? key,
      this.kColorWhite,
      this.kColorPrimary,
      this.kColorBlack,
      required this.videoPlayerSreenController})
      : super(key: key);
  late LandscapeController controller = Get.put(LandscapeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => videoPlayerSreenController.isInitialized.value
            ? LandscapeVideo(controller: videoPlayerSreenController)
            : Container(
                color: kColorBlack,
                child: Center(
                    child: CircularProgressIndicator(
                  color: kColorPrimary,
                ))),
      ),
    );
  }
}
