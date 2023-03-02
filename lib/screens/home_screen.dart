import 'package:blood_connection/components/components.dart';
import 'package:blood_connection/components/request_data_model.dart';
import 'package:blood_connection/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:blood_connection/widgets/widgets.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _bloodType = ["AB+", "AB-", "A+", "A-", "B+", "B-", "O+", "O-"];
  String _currentSelectedValue = 'AB+';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideBar(),
      body: SafeArea(
        child: FutureBuilder(
          future: MongoDB.getData(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              var totalData = snapshot.data.length;
              return CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(14.0),
                    sliver: SliverToBoxAdapter(
                      child: Container(
                        height: 54,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Palette.card,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 1.0,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 10.0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Builder(builder: (context) {
                                      return IconButton(
                                        splashRadius: 8.0,
                                        onPressed: () {
                                          Scaffold.of(context).openDrawer();
                                        },
                                        icon: Icon(
                                          Icons.menu_outlined,
                                          size: 24.0,
                                        ),
                                      );
                                    }),
                                    SizedBox(
                                      width: 16.9,
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const SearchScreen())),
                                        child: const Text(
                                          'Search Blood',
                                          style: TextStyle(
                                            fontSize: 19.0,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xff8C8C8C),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ProfileScreen())),
                                child: CircleAvatar(
                                  radius: 16.0,
                                  backgroundImage:
                                      AssetImage('images/avatar.png'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(17, 18, 0, 8),
                      child: Text(
                        'Our Partners',
                        style: TextStyle(
                          fontSize: 19.0,
                          fontWeight: FontWeight.w600,
                          color: Palette.outText,
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 14),
                      child: SizedBox(
                        height: 90.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 6,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4.0,
                              ),
                              child: Container(
                                height: 90.0,
                                width: 113.0,
                                decoration: BoxDecoration(
                                  color: Palette.cardBackground,
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(17, 18, 0, 8),
                      child: Text(
                        'Blood Request',
                        style: TextStyle(
                          fontSize: 19.0,
                          fontWeight: FontWeight.w600,
                          color: Palette.outText,
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        var data =
                            RequestDataModel.fromJson(snapshot.data[index]);
                        var names = data.name.split(' ');
                        var nickName = names[0].trim();
                        return BloodRequest(
                          blood_type: data.bloodType,
                          name: nickName,
                          number: data.number,
                          bag: data.bag,
                          address: data.address,
                        );
                      },
                      childCount: totalData,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(17, 18, 0, 8),
                          child: Text(
                            'Blood Donors',
                            style: TextStyle(
                              fontSize: 19.0,
                              fontWeight: FontWeight.w600,
                              color: Palette.outText,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 18, 17, 8),
                          child: Container(
                            height: 24,
                            width: 65,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Palette.outText,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: FormField<String>(
                              builder: (FormFieldState<String> state) {
                                return DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _currentSelectedValue,
                                    isDense: true,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _currentSelectedValue = newValue!;
                                      });
                                    },
                                    items: _bloodType.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 6,
                                          ),
                                          child: Text(
                                            value,
                                            style: TextStyle(
                                              color: Palette.outText,
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return DonorList();
                      },
                      childCount: 5,
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                child: Text("No Data Found"),
              );
            }
          },
        ),
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.expand_less_outlined,
        backgroundColor: Palette.cardBackground,
        overlayColor: Colors.black38,
        overlayOpacity: 0.5,
        spacing: 8,
        spaceBetweenChildren: 4,
        children: [
          SpeedDialChild(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RequestScreen(),
              ),
            ),
            child: Icon(
              Icons.bloodtype_outlined,
            ),
            label: 'Request',
            labelStyle: TextStyle(
              color: Palette.card,
            ),
            labelBackgroundColor: Colors.black,
          ),
          SpeedDialChild(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RegisterScreen(),
              ),
            ),
            child: Icon(
              Icons.bloodtype_outlined,
            ),
            label: 'Donate',
            labelStyle: TextStyle(
              color: Palette.card,
            ),
            labelBackgroundColor: Colors.black,
          ),
        ],
      ),
    );
  }
}
