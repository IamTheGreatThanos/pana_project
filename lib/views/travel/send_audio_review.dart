import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/services/main_api_provider.dart';
import 'package:pana_project/utils/const.dart';
import 'package:pana_project/widgets/showLoaderDialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

const theSource = AudioSource.microphone;

class SendAudioReviewPage extends StatefulWidget {
  SendAudioReviewPage(this.type, this.id);
  final int type;
  final int id;

  @override
  _SendAudioReviewPageState createState() => _SendAudioReviewPageState();
}

class _SendAudioReviewPageState extends State<SendAudioReviewPage> {
  Codec _codec = Codec.pcm16WAV;
  final String _mPath = 'file.wav';
  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  bool _mRecorderIsInited = false;

  late File audioFile;

  String completePath = "";

  String recordTime = '00:00:00';
  double seekWidth = 0;
  int recordState = 0;

  late Timer _timer;
  late Timer _timerForTime;

  List<Widget> bars = [
    const Spacer(),
  ];

  @override
  void initState() {
    openTheRecorder().then((value) {
      setState(() {
        _mRecorderIsInited = true;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    _timerForTime.cancel();

    _mRecorder!.closeRecorder();
    _mRecorder = null;

    super.dispose();
  }

  Future<void> openTheRecorder() async {
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    }
    await _mRecorder!.openRecorder();
    if (!await _mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
      _codec = Codec.opusWebM;
      if (!await _mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
        _mRecorderIsInited = true;
        return;
      }
    }
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.allowBluetooth |
              AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
          AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));

    _mRecorderIsInited = true;

    var directory = await getApplicationDocumentsDirectory();
    var directoryPath = '${directory.path}/records/';
    bool isDirectoryCreated = await Directory(directoryPath).exists();
    if (!isDirectoryCreated) {
      Directory(directoryPath).create().then((Directory directory) {
        print("DIRECTORY CREATED AT : " + directory.path);
      });
    }
    completePath = directoryPath + _mPath;
  }

  void record() {
    _mRecorder!
        .startRecorder(
      toFile: completePath,
      codec: _codec,
      audioSource: theSource,
    )
        .then((value) {
      setState(() {});
    });
  }

  void stopRecorder() async {
    await _mRecorder!.stopRecorder().then((value) {
      setState(() {
        audioFile = File(completePath);
      });
    });
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
        backgroundColor: AppColors.white,
        body: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(color: AppColors.white, height: 30),
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
                          'Оставьте отзыв',
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
                const Spacer(),
                Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 18),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 1000),
                            curve: Curves.easeInOut,
                            width: MediaQuery.of(context).size.width * 0.48 -
                                seekWidth,
                            height: 4,
                            color: Colors.transparent,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 18),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 1000),
                            curve: Curves.easeInOut,
                            width: seekWidth,
                            height: 4,
                            color: Colors.black,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 18),
                          child: Container(
                            width: 4,
                            height: 80,
                            decoration: const BoxDecoration(
                              color: AppColors.accent,
                              borderRadius: BorderRadius.all(
                                Radius.circular(40),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 18),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.48,
                            height: 4,
                            color: AppColors.lightGray,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.48 + 10,
                      height: 80,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: bars,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  recordTime,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 40),
                GestureDetector(
                    onTap: () {
                      recordAction();
                    },
                    child: recordState == 0
                        ? SvgPicture.asset('assets/icons/start_record.svg')
                        : recordState == 1
                            ? SvgPicture.asset('assets/icons/stop_record.svg')
                            : SvgPicture.asset('assets/icons/re_record.svg')),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text(
                    recordState == 0
                        ? 'Нажмите кнопку для записи'
                        : recordState == 1
                            ? 'Нажмите, чтобы остановить запись'
                            : 'Нажмите, чтобы перезаписать отзыв',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
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
                        if (audioFile != null && recordState == 2) {
                          saveChanges();
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Сперва запишите аудио.",
                                style: TextStyle(fontSize: 14)),
                          ));
                        }
                      },
                      child: const Text("Опубликовать отзыв",
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

  void recordAction() async {
    if (_mRecorderIsInited == true) {
      if (recordState == 0) {
        recordState = 1;
        seekWidth = MediaQuery.of(context).size.width * 0.48;
        addBars();
        addSeconds();
        record();
      } else if (recordState == 1) {
        recordState = 2;
        _timer.cancel();
        _timerForTime.cancel();
        stopRecorder();
      } else {
        seekWidth = 0;
        bars = [const Spacer()];
        recordState = 0;
        recordTime = '00:00:00';
      }
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Предоставьте доступ к микрофону из Настроек.",
            style: TextStyle(fontSize: 14)),
      ));
    }
  }

  void addSeconds() {
    _timerForTime = Timer.periodic(
      const Duration(milliseconds: 17),
      (Timer timer) {
        int minutes = int.parse(recordTime.substring(0, 2));
        int seconds = int.parse(recordTime.substring(3, 5));
        int milliseconds = int.parse(recordTime.substring(6, 8));

        if (milliseconds > 59) {
          seconds += 1;
          milliseconds = 0;
        } else {
          milliseconds += 1;
        }

        if (seconds > 59) {
          minutes += 1;
          seconds = 0;
        }

        if (minutes > 58) {
          _timer.cancel();
          _timerForTime.cancel();
          recordState = 2;
        } else {
          recordTime = '';
          if (minutes > 9) {
            recordTime += '$minutes';
          } else {
            recordTime += '0$minutes';
          }

          recordTime += ':';

          if (seconds > 9) {
            recordTime += '$seconds';
          } else {
            recordTime += '0$seconds';
          }

          recordTime += ':';

          if (milliseconds > 9) {
            recordTime += '$milliseconds';
          } else {
            recordTime += '0$milliseconds';
          }
        }

        setState(() {});
      },
    );
  }

  void addBars() {
    _timer = Timer.periodic(
      const Duration(milliseconds: 100),
      (Timer timer) {
        if (bars.length > (MediaQuery.of(context).size.width * 0.48) / 13) {
          bars.removeAt(1);
        }
        bars.add(
          Padding(
            padding: const EdgeInsets.only(right: 5, top: 38, left: 5),
            child: Container(
              width: 3,
              height: 20 + double.parse(Random().nextInt(20).toString()),
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(
                  Radius.circular(40),
                ),
              ),
            ),
          ),
        );
        setState(() {});
      },
    );
  }

  void saveChanges() async {
    showLoaderDialog(context);
    var response =
        await MainProvider().sendAudioReview(widget.type, widget.id, audioFile);

    print(response['data']);

    if (response['response_status'] == 'ok') {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response['data']['message'],
            style: const TextStyle(fontSize: 14)),
      ));
    }
  }
}
