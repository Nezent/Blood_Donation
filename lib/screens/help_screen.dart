// ignore_for_file: use_build_context_synchronously

import 'package:blood_connection/components/components.dart';
import 'package:blood_connection/screens/after_feedback.dart';
import 'package:blood_connection/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class HelpScreen extends StatefulWidget {
  final mongo.ObjectId? id;
  const HelpScreen({super.key, required this.id});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final feedback = GlobalKey<FormState>();
  var feedbackController = TextEditingController();
  var numberController = TextEditingController();
  bool isRegistering = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? Palette.cyan
              : Palette.darkSecondary,
          leading: IconButton(
            splashRadius: 8.0,
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_outlined,
              color: Palette.card,
              size: 36,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  Text(
                    'Write Your problems',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Palette.newText
                          : Palette.darkText,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Form(
                    key: feedback,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 8),
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty ||
                                  !RegExp(r'^(?:\+88|88)?(01[3-9]\d{8})+$')
                                      .hasMatch(value)) {
                                return "Enter Valid Phone Number";
                              } else {
                                return null;
                              }
                            },
                            controller: numberController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Image.asset(
                                  'images/bangladesh.png',
                                  height: 16,
                                  width: 16,
                                ),
                              ),
                              floatingLabelStyle:
                                  const TextStyle(color: Palette.violet),
                              hintText: 'Enter your Phone Number',
                              label: const Text('Phone'),
                              border: const OutlineInputBorder(),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Palette.violet,
                                ),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Palette.cyan,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 8),
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Write Someting";
                              } else {
                                return null;
                              }
                            },
                            controller: feedbackController,
                            maxLines: 8,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            decoration: const InputDecoration(
                              floatingLabelStyle:
                                  TextStyle(color: Palette.violet),
                              hintText: 'Write anything....',
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Palette.violet,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Palette.cyan,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                        Center(
                          child: GestureDetector(
                            onTap: () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              setState(() {
                                isRegistering = true;
                              });
                              if (feedback.currentState!.validate()) {
                                try {
                                  var data = FeedbackModel(
                                      number: (numberController.text.length ==
                                              11)
                                          ? ('+88${numberController.text}')
                                          : (numberController.text.length == 13)
                                              ? ('+${numberController.text}')
                                              : numberController.text,
                                      feedback: feedbackController.text);
                                  await MongoDB.feedback(data);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AfterFeedback(id: widget.id),
                                    ),
                                  );
                                } catch (_) {
                                  return;
                                }
                              }
                              setState(() {
                                isRegistering = false;
                              });
                            },
                            child: Container(
                              height: 46,
                              width: 340,
                              decoration: BoxDecoration(
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Palette.cyan
                                    : Palette.darkSecondary,
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Center(
                                child: isRegistering
                                    ? const JumpingDots(
                                        color: Palette.card,
                                        animationDuration:
                                            Duration(milliseconds: 500),
                                        radius: 8,
                                        numberOfDots: 3,
                                      )
                                    : Text(
                                        'Submit',
                                        style: TextStyle(
                                          fontSize: 19.0,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).brightness ==
                                                  Brightness.light
                                              ? Palette.card
                                              : Palette.darkText,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
