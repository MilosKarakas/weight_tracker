import 'package:flutter/material.dart';
import 'package:weight_tracker/helpers/modals_helper.dart';
import 'package:weight_tracker/models/weight_model.dart';
import 'package:weight_tracker/screens/sign_in.dart';
import 'package:weight_tracker/services/auth_service.dart';
import 'package:weight_tracker/services/data_service.dart';
import 'package:weight_tracker/widgets/weight_list_tile.dart';
import 'package:weight_tracker/widgets/wt_input_field.dart';

import '../service_locator.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool? _gaining;
  bool _showFloatingActionButton = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: StreamBuilder<List<WeightModel>>(
            stream: dataStream(),
            builder: (context, snapshot) {
              if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                _gaining = _gainingWeight(snapshot.data!);
                return ListView(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 64.0, bottom: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hi!',
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 28.0,
                                fontWeight: FontWeight.w800,
                                color: Colors.white),
                          ),
                          IconButton(
                              icon: Icon(
                                Icons.login_outlined,
                                color: Colors.white,
                              ),
                              onPressed: () => signOut(context))
                        ],
                      ),
                    ),
                    if (_gaining != null)
                      Row(
                        children: [
                          Text(
                            'Your weight is currently going ',
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                          SizedBox(
                            width: 4.0,
                          ),
                          if (_gaining!)
                            Icon(
                              Icons.trending_up,
                              color: Colors.green[600],
                            ),
                          if (!_gaining!)
                            Icon(
                              Icons.trending_down,
                              color: Colors.red[700],
                            )
                        ],
                      ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Text(
                      'These are your weight entries (Tap to edit or delete them):',
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Container(
                        margin: EdgeInsets.only(bottom: 16.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                                color: Colors.deepPurple.shade400, width: 2.0)),
                        child: Column(
                          children: List.generate(
                              snapshot.data!.length,
                              (index) => WeightListTile(snapshot.data![index],
                                  index == snapshot.data!.length - 1)),
                        )),
                  ],
                );
              }

              return ListView(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(top: 64.0, bottom: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hi!',
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 28.0,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white),
                            ),
                            IconButton(
                                icon: Icon(
                                  Icons.login_outlined,
                                  color: Colors.white,
                                ),
                                onPressed: () => signOut(context))
                          ],
                        )),
                    Text(
                      "You don't have any entries yet. Use the floating action button at the bottom to insert new entries.",
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    )
                  ]);
            }),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: _showFloatingActionButton
          ? Builder(
              builder: (context) => FloatingActionButton(
                tooltip: 'Add new',
                onPressed: () => addWeight(context),
                child: Icon(Icons.add),
              ),
            )
          : null, // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void changeFloatingActionButtonVisibillity() {
    setState(() {
      _showFloatingActionButton = !_showFloatingActionButton;
    });
  }

  void addWeight(BuildContext context) async {
    TextEditingController _weightController = TextEditingController();
    var controller = showBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade400,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0)),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    'Insert new weight entry',
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  WTInputField(
                    label: 'Weight',
                    controller: _weightController,
                    autofocus: true,
                    textInputType:
                        TextInputType.numberWithOptions(decimal: true),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 120.0),
                    child: ElevatedButton(
                        onPressed: () =>
                            addWeightEntry(context, _weightController.text),
                        child: Center(
                          child: Text('Submit'),
                        )),
                  ),
                  SizedBox(
                    height: 16.0,
                  )
                ],
              ),
            ),
          );
        });

    changeFloatingActionButtonVisibillity();
    controller.closed.then((value) {
      changeFloatingActionButtonVisibillity();
    });
  }

  void signOut(BuildContext context) async {
    final authService = serviceLocator<AuthService>();
    showDialog(
        context: context,
        builder: (context) => Theme(
              data: Theme.of(context).copyWith(
                  buttonBarTheme: ButtonBarTheme.of(context)
                      .copyWith(alignment: MainAxisAlignment.center)),
              child: AlertDialog(
                backgroundColor: Colors.deepPurple[500],
                buttonPadding: EdgeInsets.zero,
                actionsPadding: EdgeInsets.only(bottom: 8.0),
                title: Text(
                  'Logging out',
                  style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
                content: Text(
                  'Are you sure?',
                  style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
                actions: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 120.0),
                        child: ElevatedButton(
                            onPressed: () {
                              authService.signOut();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignInScreen()),
                                  (route) => false);
                            },
                            child: Center(
                              child: Text('Yes'),
                            )),
                      ),
                      SizedBox(
                        width: 6.0,
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 120.0),
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Center(
                              child: Text('No'),
                            )),
                      )
                    ],
                  )
                ],
              ),
            ));
  }

  bool? _gainingWeight(List<WeightModel> entries) {
    return entries.length < 2 ? null : entries[0].weight > entries[1].weight;
  }

  void addWeightEntry(BuildContext context, String weight) async {
    final dataService = serviceLocator<DataService>();
    double? weightValue = double.tryParse(weight);
    if (weightValue == null) {
      ModalsHelper.snackbar(
          context, 'Please enter weight as decimal value of kilograms.');
    } else {
      bool success = await dataService
          .addWeightEntry(WeightModel(DateTime.now(), weightValue));

      if (!success) {
        ModalsHelper.snackbar(
            context, 'Could not add new entry. Please try again later.');
      } else {
        await ModalsHelper.snackbar(context, 'Entry saved.',
            backgroundColor: Colors.deepPurple.shade200);

        Navigator.pop(context);
      }
    }
  }

  Stream<List<WeightModel>> dataStream() {
    final dataService = serviceLocator<DataService>();
    return dataService.entriesStream();
  }
}
