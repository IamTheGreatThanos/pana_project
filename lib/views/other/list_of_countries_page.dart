import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pana_project/models/city.dart';
import 'package:pana_project/services/main_api_provider.dart';
import 'package:pana_project/utils/const.dart';

class ListOfCountriesPage extends StatefulWidget {
  @override
  _ListOfCountriesPageState createState() => _ListOfCountriesPageState();
}

class _ListOfCountriesPageState extends State<ListOfCountriesPage> {
  TextEditingController nameController = TextEditingController();

  List<City> cities = [];
  List<City> displayedCities = [];

  @override
  void initState() {
    getCities();
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
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Container(height: 30),
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
                          'Выберите город',
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
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          spreadRadius: 0,
                          blurRadius: 24,
                          offset: Offset(0, 4), // changes position of shadow
                        ),
                      ],
                    ),
                    child: SizedBox(
                      height: 50,
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 0, left: 10),
                            child: SizedBox(
                              height: 30,
                              width: 30,
                              child: Icon(
                                Icons.search,
                                size: 24,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.67,
                              child: TextField(
                                controller: nameController,
                                maxLength: 100,
                                decoration: const InputDecoration(
                                  counterStyle: TextStyle(
                                    height: double.minPositive,
                                  ),
                                  counterText: "",
                                  border: InputBorder.none,
                                  hintText: 'Введите город',
                                  hintStyle: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                onChanged: (value) {
                                  searchCity(value);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20, child: Divider()),
                // for (var city in displayedCities)
                //   Padding(
                //     padding: const EdgeInsets.symmetric(horizontal: 10),
                //     child: Column(
                //       children: [
                //         ListTile(
                //           title: Text(
                //             city.name ?? '',
                //             style: TextStyle(fontWeight: FontWeight.w500),
                //           ),
                //           subtitle: Text(AppConstants
                //               .countries[(city.countryId ?? 1) - 1]),
                //           trailing: const Icon(Icons.arrow_forward_ios),
                //           onTap: () {
                //             Navigator.pop(context, [city.id, city.name]);
                //           },
                //         ),
                //         const Divider(),
                //       ],
                //     ),
                //   )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getCities() async {
    cities = [];

    var response = await MainProvider().getCities(1);
    if (response['response_status'] == 'ok') {
      for (var object in response['data']) {
        cities.add(City.fromJson(object));
      }

      displayedCities = cities;

      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response['data']['message'],
            style: const TextStyle(fontSize: 14)),
      ));
    }
  }

  void searchCity(String text) async {
    displayedCities = [];
    for (var city in cities) {
      if (city.name?.contains(text) ?? false) {
        displayedCities.add(city);
      }
    }
    setState(() {});
  }
}
