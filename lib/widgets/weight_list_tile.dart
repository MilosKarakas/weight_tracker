import 'package:flutter/material.dart';
import 'package:weight_tracker/models/weight_model.dart';
import 'package:weight_tracker/services/data_service.dart';
import 'package:weight_tracker/widgets/wt_input_field.dart';

import '../service_locator.dart';

class WeightListTile extends StatelessWidget {
  final WeightModel _model;
  final bool _last;

  const WeightListTile(this._model, this._last);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _model.formattedTime(),
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
              Text(
                '${_model.weight}kg',
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              )
            ],
          ),
          onTap: () async {
            await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) {
                  TextEditingController _weightController =
                      TextEditingController();
                  _weightController.text = _model.weight.toString();
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
                            'Edit or remove entry',
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: 120.0),
                                child: ElevatedButton(
                                    onPressed: () {
                                      editWeight(
                                          context, _weightController.text);
                                      Navigator.pop(context);
                                    },
                                    child: Center(
                                      child: Text('Save'),
                                    )),
                              ),
                              SizedBox(
                                width: 32.0,
                              ),
                              ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: 120.0),
                                child: ElevatedButton(
                                    onPressed: () {
                                      deleteWeight(context, _model);
                                      Navigator.pop(context);
                                    },
                                    child: Center(
                                      child: Text('Remove'),
                                    )),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 16.0,
                          )
                        ],
                      ),
                    ),
                  );
                });
          },
        ),
        if (!_last)
          SizedBox(
            width: double.infinity,
            height: 1.0,
            child: Material(
              color: Colors.white12,
            ),
          )
      ],
    );
  }

  void editWeight(BuildContext context, String weight) {
    final dataService = serviceLocator<DataService>();
    dataService.editWeightEntry(
        _model.copyWith(time: DateTime.now(), weight: double.parse(weight)));
  }

  void deleteWeight(BuildContext context, WeightModel model) {
    final dataService = serviceLocator<DataService>();
    dataService.removeWeightEntry(_model);
  }
}
