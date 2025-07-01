import 'package:DSTokenBam/DSTokenBam.dart';

/// Singleton del SDK DSTokenBam
class DSTokenBamProvider {
  DSTokenBamProvider._();

  static final DSTokenBamProvider instance = DSTokenBamProvider._();

  DSTokenBam? _dsTokenBam;

  /// Getter del SDK DSTokenBam
  DSTokenBam get dsTokenBam {
    if (_dsTokenBam == null) {
      _dsTokenBam = DSTokenBam();
    }
    return _dsTokenBam!;
  }

  /// Setter del SDK DSTokenBam
  set dsTokenBam(DSTokenBam dsTokenBam) {
    _dsTokenBam = dsTokenBam;
  }
}
