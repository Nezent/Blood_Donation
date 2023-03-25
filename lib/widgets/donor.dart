import 'package:blood_connection/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class DonorList extends StatefulWidget {
  String blood_type, name, number, address;
  double distance;
  DonorList({
    Key? key,
    required this.blood_type,
    required this.name,
    required this.number,
    required this.address,
    required this.distance,
  }) : super(key: key);

  @override
  State<DonorList> createState() => _DonorListState();
}

class _DonorListState extends State<DonorList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4.0,
        horizontal: 17.0,
      ),
      child: Container(
        height: 68.0,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Palette.card,
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
                      color: Palette.cyanLight,
                      borderRadius: BorderRadius.circular(
                        31.0,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        widget.blood_type,
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color: Palette.cyanText,
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
                          style: const TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.w600,
                            color: Palette.newText,
                          ),
                        ),
                        const SizedBox(
                          height: 11.0,
                        ),
                        Row(
                          children: [
                            Text(
                              widget.name,
                              style: const TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                                color: Palette.newText,
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
                                color: Palette.cyanText,
                              ),
                            ),
                            const SizedBox(
                              width: 4.0,
                            ),
                            Expanded(
                              child: Text(
                                '${(widget.distance / 1000).toStringAsFixed(2)} km Away',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.w500,
                                  color: Palette.newText,
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
                      width: MediaQuery.of(context).size.width * 0.22,
                      decoration: BoxDecoration(
                        color: Palette.cyan,
                        borderRadius: BorderRadius.circular(4.0),
                        border: Border.all(
                          width: 1.0,
                          color: Palette.cyan,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Icon(
                            Icons.call_outlined,
                            color: Palette.card,
                          ),
                          Text(
                            'Call',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                              color: Palette.card,
                            ),
                          ),
                        ],
                      ),
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
