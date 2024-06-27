import 'package:infinite_horizons/domain/objects/study_type_abstract.dart';
import 'package:infinite_horizons/domain/objects/tip.dart';

class StudyTypeAnalytical extends StudyTypeAbstract {
  StudyTypeAnalytical() : super(TipType.analytical);

  @override
  List<Tip> getTips() => tipsList
      .where(
        (element) =>
            element.type == TipType.general ||
            element.type == TipType.analytical,
      )
      .toList();
}
