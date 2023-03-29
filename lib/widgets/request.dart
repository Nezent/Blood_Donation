// ignore_for_file: non_constant_identifier_names

import 'package:blood_connection/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class BloodRequest extends StatefulWidget {
  String blood_type, name, number, address;
  int bag;
  double distance;
  BloodRequest({
    Key? key,
    required this.blood_type,
    required this.name,
    required this.number,
    required this.bag,
    required this.address,
    required this.distance,
  }) : super(key: key);

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
          color: Theme.of(context).brightness == Brightness.light
              ? Palette.card
              : Palette.darkSecondary,
          borderRadius: BorderRadius.circular(4.0),
          boxShadow: const [
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 40.0,
                    width: 40.0,
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Palette.cyanLight
                          : Palette.darkWidget,
                      borderRadius: BorderRadius.circular(
                        31.0,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        widget.blood_type,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Palette.cyanText
                                  : Palette.darkText,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 14,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.address,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.w600,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Palette.newText
                                    : Palette.darkText,
                          ),
                        ),
                        const SizedBox(
                          height: 11.0,
                        ),
                        Row(
                          children: [
                            Text(
                              widget.name,
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Palette.newText
                                    : Palette.darkText,
                              ),
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            Container(
                              height: 6.0,
                              width: 6.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3.0),
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Palette.cyanText
                                    : Palette.darkButton,
                              ),
                            ),
                            const SizedBox(
                              width: 4.0,
                            ),
                            Expanded(
                              child: Text(
                                '${(widget.distance / 1000).toStringAsFixed(2)} km Away',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Palette.newText
                                      : Palette.darkText,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 14,
                  ),
                  GestureDetector(
                    onTap: _callNumber,
                    child: Container(
                      height: 40.0,
                      width: MediaQuery.of(context).size.width * 0.272,
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Palette.cyan
                            : Palette.darkButton,
                        borderRadius: BorderRadius.circular(4.0),
                        border: Border.all(
                          width: 1.0,
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Palette.cyan
                                  : Palette.darkButton,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.call_outlined,
                            color: Palette.card,
                          ),
                          Text(
                            'Donate',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Palette.card
                                  : Palette.darkText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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
                    final double left = 1 / widget.bag;
                    double barWidth = left * maxBarWidth;

                    return Stack(
                      children: [
                        Container(
                          height: 5.0,
                          width: maxBarWidth,
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Palette.cyanLight
                                  : Palette.darkButton,
                        ),
                        Container(
                          height: 5.0,
                          width: barWidth,
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Palette.cyan
                                  : Palette.darkWidget,
                        ),
                      ],
                    );
                  }),
                  Text(
                    '${widget.bag}/${widget.bag} Units',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Palette.newText
                          : Palette.darkText,
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
