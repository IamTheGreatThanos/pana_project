import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pana_project/models/housingCard.dart';
import 'package:pana_project/models/impressionCard.dart';
import 'package:pana_project/services/main_api_provider.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/views/home/tabbar_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ReelsVideoSelectionPage extends StatefulWidget {
  ReelsVideoSelectionPage(
      this.type, this.housing, this.impression, this.fromHomePage);
  final String type;
  final HousingCardModel housing;
  final ImpressionCardModel impression;
  final bool fromHomePage;

  @override
  _ReelsVideoSelectionPageState createState() =>
      _ReelsVideoSelectionPageState();
}

class _ReelsVideoSelectionPageState extends State<ReelsVideoSelectionPage> {
  late VideoPlayerController _videoController;
  final ImagePicker _picker = ImagePicker();
  XFile? video;
  File? thumbnail;
  bool picSelected = false;
  bool isLoadingStarts = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Container(color: AppColors.white, height: 40),
                Container(
                  color: Colors.white,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child:
                                SvgPicture.asset('assets/icons/back_arrow.svg'),
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'Ваше видео',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Padding(
                        padding: EdgeInsets.only(right: 0),
                        child: SizedBox(
                          height: 50,
                          width: 50,
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                  child: !picSelected
                      ? GestureDetector(
                          onTap: () {
                            selectVideo();
                          },
                          child: DottedBorder(
                            color: AppColors.accent,
                            strokeWidth: 1,
                            dashPattern: const [6, 2],
                            strokeCap: StrokeCap.round,
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(8),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              child: Container(
                                width: double.infinity,
                                height:
                                    (MediaQuery.of(context).size.width - 160) *
                                        1.6,
                                decoration: const BoxDecoration(
                                  color: AppColors.white,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.add, color: AppColors.accent),
                                    Text(
                                      'Добавить',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.accent),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : _videoController.value.isInitialized
                          ? Stack(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _videoController.value.isPlaying
                                        ? _videoController.pause()
                                        : _videoController.play();
                                    setState(() {});
                                  },
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                    child: Container(
                                      color: AppColors.lightGray,
                                      width: double.infinity,
                                      height:
                                          (MediaQuery.of(context).size.width -
                                                  160) *
                                              1.6,
                                      child: VideoPlayer(_videoController),
                                    ),
                                  ),
                                ),
                                ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                  child: Container(
                                    width: double.infinity,
                                    height: (MediaQuery.of(context).size.width -
                                            160) *
                                        1.6,
                                    child: AnimatedSwitcher(
                                      duration:
                                          const Duration(milliseconds: 50),
                                      reverseDuration:
                                          const Duration(milliseconds: 200),
                                      child: _videoController.value.isPlaying
                                          ? const SizedBox.shrink()
                                          : GestureDetector(
                                              onTap: () {
                                                _videoController.value.isPlaying
                                                    ? _videoController.pause()
                                                    : _videoController.play();
                                                setState(() {});
                                              },
                                              child: Container(
                                                width: 80,
                                                height: 80,
                                                decoration: const BoxDecoration(
                                                    color: Colors.black26,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                40))),
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.play_arrow,
                                                    color: Colors.white,
                                                    size: 50,
                                                    semanticLabel: 'Play',
                                                  ),
                                                ),
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                                isLoadingStarts
                                    ? ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8)),
                                        child: Container(
                                          color: Colors.black26,
                                          width: double.infinity,
                                          height: (MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  160) *
                                              1.6,
                                          child: const Center(
                                            child: SizedBox(
                                              width: 80,
                                              height: 80,
                                              child: CircularProgressIndicator(
                                                color: AppColors.grey,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            )
                          : ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                              child: Container(
                                color: AppColors.lightGray,
                                width: double.infinity,
                                height:
                                    (MediaQuery.of(context).size.width - 160) *
                                        1.6,
                                child: const Center(
                                  child: SizedBox(
                                    width: 80,
                                    height: 80,
                                    child: CircularProgressIndicator(
                                      color: AppColors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                ),
                const SizedBox(height: 20),
                picSelected
                    ? GestureDetector(
                        onTap: () {
                          if (!isLoadingStarts) {
                            selectVideo();
                          }
                        },
                        child: const Text(
                          'Выбрать другое видео',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                            color: AppColors.accent,
                          ),
                        ),
                      )
                    : const SizedBox(),
                picSelected ? const SizedBox(height: 20) : const SizedBox(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Категория',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Spacer(),
                          Text(
                            widget.type == 'housing'
                                ? widget.housing.category?.name ?? ''
                                : widget.impression.topic?[0].name ?? '',
                            style: const TextStyle(
                              color: AppColors.blackWithOpacity,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 25),
                      Row(
                        children: [
                          const Text(
                            'Локация',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            widget.type == 'housing'
                                ? '${widget.housing.city?.name ?? ''}, ${widget.housing.country?.name ?? ''}'
                                : '${widget.impression.city?.name ?? ''}, ${widget.impression.country?.name ?? ''}',
                            style: const TextStyle(
                              color: AppColors.blackWithOpacity,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 25),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: SizedBox(
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: AppColors.accent,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // <-- Radius
                        ),
                      ),
                      onPressed: () {
                        if (picSelected &&
                            video != null &&
                            thumbnail != null &&
                            isLoadingStarts == false) {
                          uploadVideo();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Загрузите видео.',
                                style: const TextStyle(fontSize: 14)),
                          ));
                        }
                      },
                      child: const Text("Загрузить",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void selectVideo() async {
    final XFile? selectedVideo =
        await _picker.pickVideo(source: ImageSource.gallery);
    if (selectedVideo != null) {
      final uint8list = await VideoThumbnail.thumbnailData(
        video: selectedVideo.path,
        imageFormat: ImageFormat.JPEG,
        maxWidth:
            128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
        quality: 25,
      );
      final tempDir = await getTemporaryDirectory();
      File thumFile = await File('${tempDir.path}/image.png').create();
      thumFile.writeAsBytesSync(uint8list!);

      setState(() {
        picSelected = true;
        video = selectedVideo;
        thumbnail = thumFile;

        _videoController = VideoPlayerController.file(File(video!.path))
          ..setLooping(true)
          ..initialize().then((_) {
            setState(() {});
          });
        _videoController.play();
        setState(() {});
      });
    }
  }

  void uploadVideo() async {
    setState(() {
      isLoadingStarts = true;
    });

    var response = await MainProvider().uploadReels(
        widget.type,
        widget.type == 'housing' ? widget.housing.id! : widget.impression.id!,
        widget.type == 'housing'
            ? widget.housing.city!.id!
            : widget.impression.city!.id!,
        widget.type == 'housing'
            ? widget.housing.category!.id!
            : widget.impression.topic![0].id!,
        video!,
        thumbnail!);
    if (response['response_status'] == 'ok') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Видео успешно загружено!',
            style: const TextStyle(fontSize: 14)),
      ));

      if (widget.fromHomePage) {
        Future.delayed(
          const Duration(seconds: 3),
        ).whenComplete(() => Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => TabBarPage()),
            (Route<dynamic> route) => false));
      } else {
        Navigator.pop(context);
      }
    } else {
      setState(() {
        isLoadingStarts = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Ошибка загрузки!', style: TextStyle(fontSize: 14)),
      ));
    }
  }
}
