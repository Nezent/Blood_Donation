import 'package:blood_connection/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class BloodRequest extends StatefulWidget {
  String blood_type, name, number;
  int bag;
  BloodRequest(
      {Key? key,
      required this.blood_type,
      required this.name,
      required this.number,
      required this.bag})
      : super(key: key);

  @override
  State<BloodRequest> createState() => _BloodRequestState();
}

class _BloodRequestState extends State<BloodRequest> {
  int totalBag = 4;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 2.0,
        horizontal: 17.0,
      ),
      child: Container(
        height: 99.0,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Palette.card,
          borderRadius: BorderRadius.circular(4.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 1.0,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                    color: Palette.outText,
                    borderRadius: BorderRadius.circular(
                      31.0,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      widget.blood_type,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black38,
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dhaka,Bangladesh',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        color: Palette.text,
                      ),
                    ),
                    SizedBox(
                      height: 11.0,
                    ),
                    Row(
                      children: [
                        Text(
                          widget.name,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            color: Palette.text,
                          ),
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Container(
                          height: 6.0,
                          width: 6.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3.0),
                            color: Palette.outText,
                          ),
                        ),
                        SizedBox(
                          width: 4.0,
                        ),
                        Text(
                          '500 m Away',
                          style: TextStyle(
                            fontSize: 11.0,
                            fontWeight: FontWeight.w500,
                            color: Palette.text,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: _callNumber,
                  child: Container(
                    height: 40.0,
                    width: MediaQuery.of(context).size.width * 0.272,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      border: Border.all(
                        width: 1.0,
                        color: Palette.text,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.call_outlined,
                          color: Palette.text,
                        ),
                        Text(
                          'Donate',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            color: Palette.text,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  LayoutBuilder(builder:
                      (BuildContext context, BoxConstraints constraints) {
                    double maxBarWidth =
                        MediaQuery.of(context).size.width * 0.65;
                    final double left = widget.bag / totalBag;
                    double barWidth = left * maxBarWidth;

                    return Stack(
                      children: [
                        Container(
                          height: 5.0,
                          width: maxBarWidth,
                          color: Palette.cardBackground,
                        ),
                        Container(
                          height: 5.0,
                          width: barWidth,
                          color: Palette.outText,
                        ),
                      ],
                    );
                  }),
                  Text(
                    '${widget.bag}/$totalBag Units',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: Palette.text,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _callNumber() async {
    String number = widget.number; //set the number here
    await FlutterPhoneDirectCaller.callNumber(number);
  }
}
