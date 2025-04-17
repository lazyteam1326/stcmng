import 'package:flutter/material.dart';

// ignore: must_be_immutable
class EditName extends StatefulWidget {
  const EditName({super.key});

  @override
  State<EditName> createState() => _EditNameState();
}

// ignore: camel_case_types
class _EditNameState extends State<EditName> {
  late String nameValue;
  Color nextPhoneColor = Colors.white;
  Color nextTextColor = const Color.fromARGB(82, 61, 61, 61);
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * .05),
              Row(children: [SizedBox(width: screenHeight * .01)]),
              SizedBox(height: screenHeight * .02),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Edit page',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w800,
                        fontSize: 23,
                        //letterSpacing: 1,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    SizedBox(height: screenHeight * .01),
                    Text(
                      'Edit Name',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                        //letterSpacing: 0.5,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    SizedBox(height: screenHeight * .02),
                    Text(
                      'name',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        letterSpacing: 0.5,
                      ),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelStyle: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 224, 224, 224),
                          ), // Specify your desired color
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 0, 0, 0),
                          ), // Specify your desired color
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                      style: const TextStyle(fontSize: 15),
                      onChanged: (name) {
                        if (name.isNotEmpty) {
                          setState(() {
                            nameValue = name;
                            nextPhoneColor = Colors.black;
                            nextTextColor = Colors.white;
                          });
                        } else {
                          setState(() {
                            nextPhoneColor = Colors.white;
                            nextTextColor = const Color.fromARGB(
                              82,
                              61,
                              61,
                              61,
                            );
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
