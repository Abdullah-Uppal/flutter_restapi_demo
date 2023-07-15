import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:mad_assignment_3/controllers/services_controller.dart';

class CreateService extends StatefulWidget {
  final VoidCallback refresh;
  const CreateService({super.key, required this.refresh});

  @override
  State<CreateService> createState() => _CreateServiceState();
}

class _CreateServiceState extends State<CreateService> {
  bool active = true;
  bool inactive = false;

  String title = "";
  String description = "";
  String status = "Active";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create New Service"),
      ),
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          TextField(
            decoration: InputDecoration(label: Text("Title")),
            onChanged: (value) {
              title = value;
            },
          ),
          TextField(
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
                      ServicesController().create({
                        "title": title,
                        "description": description,
                        "status": status,
                      }).then((value) {
                        if (value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Successfully Created")),
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
                    child: Text("Create"),
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
