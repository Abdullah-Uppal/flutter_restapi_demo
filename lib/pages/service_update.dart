import 'package:flutter/material.dart';
import 'package:mad_assignment_3/controllers/services_controller.dart';
import 'package:mad_assignment_3/models/service.dart';

class UpdateService extends StatefulWidget {
  final Service service;
  final VoidCallback refresh;
  const UpdateService({super.key, required this.refresh, required this.service});

  @override
  State<UpdateService> createState() => _UpdateServiceState();
}

class _UpdateServiceState extends State<UpdateService> {
  bool active = true;
  bool inactive = false;

  String title = "";
  String description = "";
  String status = "Active";
  late TextEditingController title_controller;
  late TextEditingController description_controller;
  @override
  void initState() {
    super.initState();
    title = widget.service.title;
    description = widget.service.description;
    status = widget.service.status;
    active = widget.service.status == "Active";
    inactive = !active;
    title_controller = TextEditingController(text: title);
    description_controller = TextEditingController(text: description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Service"),
      ),
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          TextField(
            controller: title_controller,
            decoration: InputDecoration(label: Text("Title")),
            onChanged: (value) {
              title = value;
            },
          ),
          TextField(
            controller: description_controller,
            maxLines: 2,
            decoration: InputDecoration(label: Text("Description")),
            onChanged: (value) {
              description = value;
            },
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ToggleButtons(
                borderRadius: BorderRadius.circular(5),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Active"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Inactive"),
                  ),
                ],
                isSelected: [active, inactive],
                onPressed: (index) {
                  setState(() {
                    active = !active;
                    inactive = !inactive;
                  });
                  status = active ? "Active" : "InActive";
                },
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel"),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (title.trim() == "" || description.trim() == "") {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please fill the fields")),
                        );
                        return;
                      }
                      print(
                        widget.service.id.toString());
                      ServicesController().update({
                        "id": widget.service.id.toString(),
                        "title": title,
                        "description": description,
                        "status": status,
                      }).then((value) {
                        print("value updated " + value.toString());
                        if (value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Successfully Updated")),
                          );
                          widget.refresh();
                        }
                        else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Failed")),
                          );

                        }
                      });
                    },
                    child: Text("Update"),
                  ),
                ],
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
