import 'package:date_format/date_format.dart';
import 'package:equatable/equatable.dart';

class WeightModel implements Equatable {
  final DateTime time;
  final double weight;
  final String? id;

  WeightModel(this.time, this.weight, {this.id = ''});

  @override
  List<Object?> get props => [this.time, this.weight];

  @override
  bool? get stringify => false;

  Map<String, dynamic> toJson() {
    return {'time': time.millisecondsSinceEpoch, 'weight': weight};
  }

  factory WeightModel.fromJson(Map<String, dynamic> json) {
    return WeightModel(
        DateTime.fromMillisecondsSinceEpoch(json['time']), json['weight']);
  }

  factory WeightModel.fromFirestore(Map<String, dynamic> json, String id) {
    return WeightModel(
        DateTime.fromMillisecondsSinceEpoch(json['time']), json['weight'],
        id: id);
  }

  String formattedTime() {
    return formatDate(
        time, ['dd', '.', 'mm', '.', 'yyyy', '. ', 'HH', ':', 'nn']);
  }

  WeightModel copyWith({
    DateTime? time,
    double? weight,
    String? id,
  }) {
    return WeightModel(
      time ?? this.time,
      weight ?? this.weight,
      id: id ?? this.id,
    );
  }
}
