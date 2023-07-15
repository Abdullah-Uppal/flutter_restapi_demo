import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mad_assignment_3/models/service.dart';
import '../widgets/service_tile.dart';
import '../controllers/services_controller.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ValueNotifier<int> isSearchBarVisible = ValueNotifier(0);
  final controller = TextEditingController();
  final ValueNotifier<String> searchedText = ValueNotifier("");
  ServicesController servicesController = ServicesController();
  void changeVisibility() {
    isSearchBarVisible.value = (isSearchBarVisible.value + 1) % 2;
  }

  void changeSearchedText(String newText) {
    searchedText.value = newText;
  }
  @override
  Widget build(BuildContext context) {
    print("HomePage changed");
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.search_rounded),
            onPressed: changeVisibility,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                "Services",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pushNamed(
                  "/new",
                  arguments: () {
                    setState(() {
                      servicesController = ServicesController();
                    });
                  },
                );
              },
              title: Text(
                "Create New",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            )
          ],
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: searchedText,
        builder: (context, value, child) {
          return FutureBuilder(
            future: servicesController.get_services(),
            builder: (context, snapshot) {
              print("Building List");
              if (snapshot.hasData) {
                return Column(
                  children: [
                    ValueListenableBuilder(
                      valueListenable: isSearchBarVisible,
                      builder: (context, value, child) {
                        return AnimatedOpacity(
                          curve: Curves.decelerate,
                          opacity: value == 1 ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 500),
                          child: Visibility(
                            visible: (value == 1),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: CupertinoSearchTextField(
                                controller: controller,
                                onChanged: (value) {
                                  changeSearchedText(value);
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          print("Refresh");
                          setState(() {
                            servicesController = ServicesController();
                          });
                        },
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return ServiceTile(
                              service: snapshot.data![index],
                              deleteCallback: () {
                                setState(() {
                                  servicesController = ServicesController();
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: const Text("No internet connection"),
                );
              } else if (snapshot.connectionState != ConnectionState.done) {
                return Center(child: CircularProgressIndicator());
              }
              return Center(child: CircularProgressIndicator());
            },
          );
        },
      ),
    );
  }
}
