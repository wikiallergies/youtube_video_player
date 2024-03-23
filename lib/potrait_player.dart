import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

// import 'package:wakelock/wakelock.dart';

// import '../../models/video_details/video_details_model.dart';
import 'landscape_player_screen.dart';
import 'popop.dart';
// import '../../const/colors/colors.dart';
// import '../../const/constants/constants.dart';
import 'video_player_controller.dart';

class PotraitPlayer extends StatelessWidget {
  final String link;
  final double aspectRatio;
  final Color? kColorWhite;
  final Color? kColorPrimary;
  final Color? kColorBlack;
  final bool isFullScreen;

  const PotraitPlayer({
    super.key,
    required this.link,
    required this.aspectRatio,
    this.kColorWhite,
    this.kColorPrimary,
    this.kColorBlack,
    this.isFullScreen = false,
  });
  @override
  Widget build(BuildContext context) {
    // Wakelock.enable();
    final tag = DateTime.timestamp().microsecondsSinceEpoch.toString() + link;
    VideoPlayerSreenController controller = Get.put(
        VideoPlayerSreenController(
          link: link,
          key: tag,
        ),
        tag: tag);
    var unKey = UniqueKey();
    double width = MediaQuery.of(context).size.width;
    // File myAsset = File("packages/youtube_video_player/lib/assets/10for.svg");
    // controller.manifest =
    // controller.controller = VideoPlayerController.networkUrl(element.url,
    //     videoPlayerOptions: VideoPlayerOptions())
    //   ..initialize().then((value) {
    //     controller.controller.seekTo(position);
    //     controller.isInitialized.value = true;
    //     controller.controller.play();
    //     controller.isPlaying.value = true;
    //   });
    return OrientationBuilder(builder: (context, orientation) {
      return orientation == Orientation.portrait
          ? GestureDetector(
              child: AspectRatio(
                aspectRatio: aspectRatio,
                child: Obx(
                  () => GestureDetector(
                    onTap: () {
                      controller.isVisible.value = !controller.isVisible.value;
                      Future.delayed(const Duration(seconds: 5), () {
                        controller.isVisible.value = false;
                      });
                    },
                    child: controller.isInitialized.value
                        ? Stack(
                            fit: StackFit.passthrough,
                            children: [
                              VisibilityDetector(
                                key: unKey,
                                onVisibilityChanged: (info) {
                                  if (info.visibleFraction < 0.1) {
                                    controller.controller.pause();
                                  }
                                },
                                child: VideoPlayer(controller.controller),
                              ), //Video Player
                              Obx(
                                () => controller.caption.isNotEmpty
                                    ? ClosedCaption(
                                        text: controller.currentSubtitle?.data,
                                        textStyle: const TextStyle(
                                            fontSize: 15, color: Colors.white),
                                      )
                                    : const SizedBox.shrink(),
                              ), //Captions
                              Visibility(
                                visible: controller.isVisible.value,
                                // visible: true,
                                child: Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.black45),
                                  height: double.infinity,
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            TextButton(
                                              child: SvgPicture.asset(
                                                "assets/icons/10rev.svg",
                                                width: 30,
                                                height: 30,
                                                package: "youtube_video_player",
                                              ),
                                              onPressed: () {
                                                controller.controller.seekTo(
                                                    controller.controller.value
                                                            .position -
                                                        const Duration(
                                                            seconds: 10));
                                              },
                                            ),
                                            TextButton(
                                              child: SvgPicture.asset(
                                                controller.isPlaying.value
                                                    ? "assets/icons/pause_video.svg"
                                                    : "assets/icons/play_video.svg",
                                                width: 48,
                                                package: "youtube_video_player",
                                              ),
                                              onPressed: () {
                                                controller.isPlaying.value =
                                                    !controller.isPlaying.value;
                                                controller.controller.value
                                                        .isPlaying
                                                    ? controller.controller
                                                        .pause()
                                                    : controller.controller
                                                        .play();
                                              },
                                            ),
                                            TextButton(
                                              child: SvgPicture.asset(
                                                  "assets/icons/10for.svg",
                                                  width: 30,
                                                  height: 30,
                                                  package:
                                                      "youtube_video_player"),
                                              onPressed: () {
                                                controller.controller.seekTo(
                                                    controller.controller.value
                                                            .position +
                                                        const Duration(
                                                            seconds: 10));
                                              },
                                            ),
                                          ],
                                        ),
                                      ), //Controls

                                      // Container(
                                      //     padding: EdgeInsets.only(
                                      //         top: 230.w, left: 25.w, right: 25.w),
                                      //     //Duration
                                      //     child: Row(
                                      //       mainAxisAlignment:
                                      //           MainAxisAlignment.spaceBetween,
                                      //       children: [
                                      //         RichText(
                                      //           text: TextSpan(
                                      //             text: controller.formatDuration(
                                      //                 controller.position.value),
                                      //             style: const TextStyle(
                                      //               fontSize: 10.0,
                                      //               color: Colors.white,
                                      //               decoration: TextDecoration.none,
                                      //             ),
                                      //           ),
                                      //         ),
                                      //         Text(
                                      //           controller.formatDuration(
                                      //               controller.duration.value),
                                      //           style: const TextStyle(
                                      //             fontSize: 10.0,
                                      //             color: Colors.white,
                                      //             decoration: TextDecoration.none,
                                      //           ),
                                      //         ),
                                      //       ],
                                      //     )),

                                      //Brightness and VOlume Sliders
                                      Positioned(
                                        bottom: width >= 600 ? 130 : 75,
                                        left: 10,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Visibility(
                                              visible: controller
                                                  .brightVisible.value,
                                              child: RotatedBox(
                                                quarterTurns: -1,
                                                child: SizedBox(
                                                  width: 80,
                                                  // margin: EdgeInsets.only(
                                                  //     top: 30.w,
                                                  //     bottom: 30.w,
                                                  //     left: 20.w,
                                                  //     right: 18.w),
                                                  child: SliderTheme(
                                                    data: const SliderThemeData(
                                                        trackHeight: 2,
                                                        thumbShape:
                                                            RoundSliderThumbShape(
                                                                enabledThumbRadius:
                                                                    6),
                                                        overlayShape:
                                                            RoundSliderOverlayShape(
                                                                overlayRadius:
                                                                    1),
                                                        thumbColor:
                                                            Colors.white,
                                                        activeTrackColor:
                                                            Colors.white,
                                                        inactiveTrackColor:
                                                            Colors.grey),
                                                    child: Slider(
                                                      value: controller
                                                          .setBrightness.value,
                                                      min: 0.0,
                                                      max: 1.0,
                                                      // divisions: duration.value.inSeconds.round(),
                                                      onChanged:
                                                          (double newValue) {
                                                        // position.value =
                                                        // Duration(seconds: newValue.toInt());
                                                        controller.setBrightness
                                                            .value = newValue;
                                                        ScreenBrightness()
                                                            .setScreenBrightness(
                                                                newValue);
                                                      },
                                                      mouseCursor: MouseCursor
                                                          .uncontrolled,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 55,
                                              height: 55,
                                              child: TextButton(
                                                  onPressed: () {
                                                    controller.brightVisible
                                                            .value =
                                                        !controller
                                                            .brightVisible
                                                            .value;
                                                    Future.delayed(
                                                        const Duration(
                                                            seconds: 5),
                                                        () => controller
                                                            .brightVisible
                                                            .value = false);
                                                  },
                                                  child: SvgPicture.asset(
                                                    "assets/icons/brightness.svg",
                                                    package:
                                                        "youtube_video_player",
                                                    height: 20,
                                                    width: 20,
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        bottom: width >= 600 ? 130 : 75,
                                        right: 10,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Visibility(
                                              visible:
                                                  controller.volVisible.value,
                                              child: RotatedBox(
                                                quarterTurns: -1,
                                                child: SizedBox(
                                                  width: 90,
                                                  // margin: EdgeInsets.only(
                                                  //     top: 30.w,
                                                  //     bottom: 30.w,
                                                  //     left: 20.w,
                                                  //     right: 18.w),
                                                  child: SliderTheme(
                                                    data: const SliderThemeData(
                                                        trackHeight: 2,
                                                        thumbShape:
                                                            RoundSliderThumbShape(
                                                                enabledThumbRadius:
                                                                    6),
                                                        overlayShape:
                                                            RoundSliderOverlayShape(
                                                                overlayRadius:
                                                                    1),
                                                        thumbColor:
                                                            Colors.white,
                                                        activeTrackColor:
                                                            Colors.white,
                                                        inactiveTrackColor:
                                                            Colors.grey),
                                                    child: Slider(
                                                      value: controller
                                                          .setVolumeValue.value,
                                                      min: 0.0,
                                                      max: 1.0,
                                                      // divisions: duration.value.inSeconds.round(),
                                                      onChanged:
                                                          (double newValue) {
                                                        // position.value =
                                                        // Duration(seconds: newValue.toInt());
                                                        controller
                                                            .setVolumeValue
                                                            .value = newValue;
                                                        controller.setVolumeValue
                                                                    .value ==
                                                                0
                                                            ? controller.isMute
                                                                .value = true
                                                            : controller.isMute
                                                                .value = false;
                                                        controller
                                                            .setVolumeValue
                                                            .value = newValue;
                                                        controller.controller
                                                            .setVolume(
                                                                newValue);
                                                        // VolumeController()
                                                        //     .setVolume(newValue);
                                                      },
                                                      mouseCursor: MouseCursor
                                                          .uncontrolled,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 55,
                                              height: 55,
                                              child: TextButton(
                                                onPressed: () {
                                                  controller.volVisible.value =
                                                      !controller
                                                          .volVisible.value;
                                                  Future.delayed(
                                                      const Duration(
                                                          seconds: 5),
                                                      () => controller
                                                          .volVisible
                                                          .value = false);
                                                },
                                                child: Obx(() =>
                                                    !controller.isMute.value
                                                        ? SvgPicture.asset(
                                                            "assets/icons/volume.svg",
                                                            package:
                                                                "youtube_video_player",
                                                            width: 20,
                                                            height: 20,
                                                          )
                                                        : SvgPicture.asset(
                                                            "assets/icons/mute.svg",
                                                            package:
                                                                "youtube_video_player",
                                                            width: 20,
                                                            height: 20,
                                                          )),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding:
                                            const EdgeInsets.only(bottom: 15),
                                        alignment: Alignment.bottomCenter,
                                        // height: 220,
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              top: 30,
                                              bottom: isFullScreen ? 30 : 0,
                                              left: 20,
                                              right: 18),
                                          child: Obx(
                                            () => ProgressBar(
                                              // key: controller.mywidgetkey.value,
                                              barHeight: 2,
                                              baseBarColor: Colors.white,
                                              bufferedBarColor:
                                                  Colors.grey[300],
                                              progressBarColor: kColorPrimary,
                                              thumbColor: kColorPrimary,
                                              thumbRadius: 5,
                                              progress:
                                                  controller.position.value,
                                              total: controller
                                                  .controller.value.duration,
                                              // buffered: controller
                                              //     .durationRangeToDuration(controller
                                              //         .controller.value.buffered),
                                              onSeek: (value) => controller
                                                  .controller
                                                  .seekTo(value),
                                              timeLabelTextStyle: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: kColorWhite,
                                                  fontSize: 10),
                                              barCapShape: BarCapShape.round,
                                              timeLabelPadding: 5,
                                              timeLabelType:
                                                  TimeLabelType.remainingTime,
                                            ),
                                          ),
                                        ), //Progress Bar
                                      ),
                                      //Bottom Bar Settings and Full Screen
                                      if (isFullScreen)
                                        Positioned(
                                            bottom: 0,
                                            right: 10,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                LandscapePlayer(
                                                              videoPlayerSreenController:
                                                                  controller,
                                                              kColorBlack:
                                                                  Colors.black,
                                                              kColorPrimary:
                                                                  Colors.orange,
                                                              kColorWhite:
                                                                  Colors.white,
                                                            ),
                                                          ));
                                                    },
                                                    style: TextButton.styleFrom(
                                                      fixedSize:
                                                          const Size(50, 50),
                                                      minimumSize:
                                                          const Size(50, 50),
                                                      maximumSize:
                                                          const Size(50, 50),
                                                    ),
                                                    child: SvgPicture.asset(
                                                      "assets/icons/fullscreen.svg",
                                                      width: 30,
                                                      height: 30,
                                                      package:
                                                          "youtube_video_player",
                                                    )),
                                                TextButton(
                                                    onPressed: () {
                                                      showModalBottomSheet(
                                                          constraints: BoxConstraints(
                                                              minWidth:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width),
                                                          context: context,
                                                          builder: (context) =>
                                                              Popup(),
                                                          isScrollControlled:
                                                              true);
                                                    },
                                                    style: TextButton.styleFrom(
                                                      fixedSize:
                                                          const Size(55, 55),
                                                      minimumSize:
                                                          const Size(55, 55),
                                                      maximumSize:
                                                          const Size(55, 55),
                                                    ),
                                                    child: SvgPicture.asset(
                                                      "assets/icons/settings.svg",
                                                      width: 30,
                                                      height: 30,
                                                      package:
                                                          "youtube_video_player",
                                                    )),
                                              ],
                                            )),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )
                        : AspectRatio(
                            aspectRatio: aspectRatio,
                            child: Container(
                                color: kColorBlack,
                                child: Center(
                                    child: CircularProgressIndicator(
                                  color: kColorPrimary,
                                ))),
                          ),
                  ),
                ),
              ),
            )
          : Container();
    });
  }
}
