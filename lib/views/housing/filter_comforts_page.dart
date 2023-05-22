import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/components/filter_checkbox_item.dart';
import 'package:pana_project/services/main_api_provider.dart';
import 'package:pana_project/utils/const.dart';

class FilterComfortsPage extends StatefulWidget {
  FilterComfortsPage(this.fromHousing, this.comforts);
  final bool fromHousing;
  final List<Map<String, dynamic>> comforts;

  @override
  _FilterComfortsPageState createState() => _FilterComfortsPageState();
}

class _FilterComfortsPageState extends State<FilterComfortsPage> {
  List<Map<String, dynamic>> comforts = [];

  bool loading = true;

  @override
  void initState() {
    if (widget.comforts.toString() != '[]') {
      comforts = widget.comforts;
      loading = false;
    } else {
      if (widget.fromHousing) {
        getComforts();
      } else {
        getTopics();
      }
    }

    super.initState();
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
        backgroundColor: AppColors.lightGray,
        body: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Container(
                  color: AppColors.white,
                  height: 20,
                ),
                Container(
                  color: AppColors.white,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop(comforts);
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(50),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: SvgPicture.asset(
                                  'assets/icons/back_arrow.svg'),
                            ),
                          ),
                        ),
                        const Spacer(),
                        const Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            'Удобства',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
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
                ),
                Container(
                    height: 2, color: AppColors.white, child: const Divider()),
                const SizedBox(height: 20),
                loading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.white,
                        ),
                      )
                    : Container(
                        decoration: const BoxDecoration(
                          color: AppColors.white,
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // TODO: Список удобств
                              for (var i in comforts)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      i['name'],
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.blackWithOpacity,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Wrap(
                                      children: [
                                        for (var j in i['comforts'])
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10),
                                            child: GestureDetector(
                                              onTap: () {
                                                j['state'] = !j['state'];
                                                setState(() {});
                                              },
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  FilterCheckboxItem(
                                                    title: j['title'],
                                                    isChecked: j['state'],
                                                    withCheckbox: true,
                                                  ),
                                                  const SizedBox(width: 10),
                                                ],
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    const Divider(),
                                    const SizedBox(height: 15),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getComforts() async {
    var responseCategories = await MainProvider().getComforts(1, 1);
    var responseComforts = await MainProvider().getComforts(1, 2);
    if (responseCategories['response_status'] == 'ok' &&
        responseComforts['response_status'] == 'ok') {
      for (int i = 0; i < responseCategories['data'].length; i++) {
        Map<String, dynamic> categoryMap = {
          'name': responseCategories['data'][i]['name'],
          'id': responseCategories['data'][i]['id']
        };
        List<Map<String, dynamic>> comfortsTemp = [];

        for (int j = 0; j < responseComforts['data'].length; j++) {
          if (responseCategories['data'][i]['id'] ==
              responseComforts['data'][j]['parent_id']) {
            comfortsTemp.add({
              'title': responseComforts['data'][j]['name'],
              'id': responseComforts['data'][j]['id'],
              'state': false
            });
          }
        }

        categoryMap['comforts'] = comfortsTemp;

        comforts.add(categoryMap);
      }
      if (mounted) {
        loading = false;
        setState(() {});
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(responseCategories['data']['message'],
            style: const TextStyle(fontSize: 14)),
      ));
    }
  }

  void getTopics() async {
    var response = await MainProvider().getTopics();

    if (response['response_status'] == 'ok') {
      Map<String, dynamic> categoryMap = {
        'name': 'Удобства',
      };
      List<Map<String, dynamic>> comfortsTemp = [];

      for (int j = 0; j < response['data'].length; j++) {
        comfortsTemp.add({
          'title': response['data'][j]['name'],
          'id': response['data'][j]['id'],
          'state': false
        });
      }

      categoryMap['comforts'] = comfortsTemp;

      comforts.add(categoryMap);

      if (mounted) {
        loading = false;
        setState(() {});
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response['data']['message'],
            style: const TextStyle(fontSize: 14)),
      ));
    }
  }
}
