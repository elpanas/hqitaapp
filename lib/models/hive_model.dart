import 'package:hive/hive.dart';
part 'hive_model.g.dart';

@HiveType(typeId: 0)
class LocalPlayer extends HiveObject {
  @HiveField(0)
  String pid;

  @HiveField(1)
  String name;

  @HiveField(2)
  String city;

  LocalPlayer({
    required this.pid,
    required this.name,
    required this.city,
  });
}
