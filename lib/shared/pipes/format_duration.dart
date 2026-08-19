// lib/shared/pipes/format_duration.dart
class FormatDurationPipe {
  String transform(int segundos) {
    if (segundos <= 0) return '0:00';

    final mins = segundos ~/ 60;
    final secs = segundos % 60;

    if (mins == 0) {
      return '0:${secs.toString().padLeft(2, '0')}';
    }

    if (mins >= 60) {
      final horas = mins ~/ 60;
      final minRest = mins % 60;
      return '$horas:${minRest.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }

    return '${mins.toString()}:${secs.toString().padLeft(2, '0')}';
  }
}

// Extensión para usar como función global
extension FormatDurationExtension on int {
  String toDurationString() {
    return FormatDurationPipe().transform(this);
  }
}
