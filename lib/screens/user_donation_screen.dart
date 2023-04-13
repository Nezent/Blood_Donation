// ignore_for_file: use_build_context_synchronously

import 'package:blood_connection/components/components.dart';
import 'package:blood_connection/screens/screens.dart';
import 'package:blood_connection/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class UserRequestScreen extends StatefulWidget {
  final List<dynamic> donations;
  final mongo.ObjectId? id;
  final int value;
  const UserRequestScreen(
      {super.key,
      required this.donations,
      required this.id,
      required this.value});

  @override
  State<UserRequestScreen> createState() => _UserRequestScreenState();
}

class _UserRequestScreenState extends State<UserRequestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "My Donations",
          style: TextStyle(
              color: Theme.of(context).brightness == Brightness.light
                  ? Palette.card
                  : Palette.darkText),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Palette.cyan
            : Palette.darkSecondary,
        leading: IconButton(
          splashRadius: 8.0,
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileScreen(id: widget.id),
            ),
          ),
          icon: const Icon(
            Icons.arrow_back_outlined,
            color: Palette.card,
            size: 36,
          ),
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: ListView.builder(
            itemCount: widget.donations.length,
            itemBuilder: (BuildContext context, int index) {
              return FutureBuilder(
                  future: MongoDB.getRequestData(widget.donations[index]),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Column(
                          children: [
                            Skeleton(
                              height: 95,
                              width: MediaQuery.of(context).size.width,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Skeleton(
                              height: 95,
                              width: MediaQuery.of(context).size.width,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Skeleton(
                              height: 95,
                              width: MediaQuery.of(context).size.width,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Skeleton(
                              height: 95,
                              width: MediaQuery.of(context).size.width,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Skeleton(
                              height: 95,
                              width: MediaQuery.of(context).size.width,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                          ],
                        ),
                      );
                    } else if (snapshot.hasData) {
                      var requestData =
                          RequestDataModel.fromJson(snapshot.data!);
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2.0,
                          horizontal: 17.0,
                        ),
                        child: Container(
                          height: 99.0,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.light
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 14),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      height: 40.0,
                                      width: 40.0,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Palette.cyanLight
                                            : Palette.darkWidget,
                                        borderRadius: BorderRadius.circular(
                                          31.0,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          requestData.bloodType,
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w500,
                                            color:
                                                Theme.of(context).brightness ==
                                                        Brightness.light
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            requestData.address,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                            style: TextStyle(
                                              fontSize: 17.0,
                                              fontWeight: FontWeight.w600,
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.light
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
                                                requestData.name,
                                                style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w500,
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.light
                                                      ? Palette.newText
                                                      : Palette.darkText,
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
                                      onTap: () async {
                                        await MongoDB.addBloodUnits(
                                            widget.donations[index],
                                            requestData.initBag + 1);
                                        await MongoDB.deleteUnitRequest(
                                            widget.id);
                                        await MongoDB.changeAvailability(
                                            widget.id, false);
                                        await MongoDB.addDonationTimes(
                                            widget.id, widget.value + 1);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AfterUnitsAdd(
                                              id: widget.id,
                                              value: widget.value,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        height: 40.0,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.204,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).brightness ==
                                                  Brightness.light
                                              ? Palette.cyan
                                              : Palette.darkButton,
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                          border: Border.all(
                                            width: 1.0,
                                            color:
                                                Theme.of(context).brightness ==
                                                        Brightness.light
                                                    ? Palette.cyan
                                                    : Palette.darkButton,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            const Icon(
                                              Icons.add,
                                              color: Palette.card,
                                            ),
                                            Text(
                                              'Add',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w500,
                                                color: Theme.of(context)
                                                            .brightness ==
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    LayoutBuilder(builder:
                                        (BuildContext context,
                                            BoxConstraints constraints) {
                                      double maxBarWidth =
                                          MediaQuery.of(context).size.width *
                                              0.65;
                                      final double left =
                                          requestData.initBag / requestData.bag;
                                      double barWidth = left * maxBarWidth;

                                      return Stack(
                                        children: [
                                          Container(
                                            height: 5.0,
                                            width: maxBarWidth,
                                            color:
                                                Theme.of(context).brightness ==
                                                        Brightness.light
                                                    ? Palette.cyanLight
                                                    : Palette.darkButton,
                                          ),
                                          Container(
                                            height: 5.0,
                                            width: barWidth,
                                            color:
                                                Theme.of(context).brightness ==
                                                        Brightness.light
                                                    ? Palette.cyan
                                                    : Palette.darkWidget,
                                          ),
                                        ],
                                      );
                                    }),
                                    Text(
                                      '${requestData.initBag}/${requestData.bag} Units',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
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
                    } else {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 17),
                        child: Container(
                          height: 94,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.light
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
                          child: Center(
                            child: Text(
                              'The User Has Found His Needs',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Palette.cyanText
                                    : Palette.darkText,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  });
            }),
      )),
    );
  }
}
