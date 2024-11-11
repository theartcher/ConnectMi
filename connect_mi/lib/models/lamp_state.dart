import 'dart:convert';
import 'dart:ui';

class LampState {
  final String? state; // On/Off state
  final String? status; // On/Off status
  final int? hue; // Color hue
  final int? saturation; // Color saturation
  final int? kelvin; // White temperature (0-100)
  final int? temperature; // Alias for kelvin
  final int? colorTemp; // White temperature in mireds (153-370)
  final int? mode; // Party mode ID
  final int? level; // Brightness on a 0-100 scale
  final int? brightness; // Brightness on a 0-255 scale
  final String? effect; // night_mode or white_mode
  final double? transition; // Transition to provided state
  final Color? color; // Color stored as a Color object

  LampState({
    this.state,
    this.status,
    this.hue,
    this.saturation,
    this.kelvin,
    this.temperature,
    this.colorTemp,
    this.mode,
    this.level,
    this.brightness,
    this.effect,
    this.transition,
    this.color,
  });

  factory LampState.fromJsonString(dynamic responseBody) {
    // If the responseBody is a String, decode it to JSON
    final Map<String, dynamic> json = responseBody is String
        ? jsonDecode(responseBody)
        : responseBody as Map<String, dynamic>;

    // Parse color from (r,g,b) object format
    Color? parseColor(Map<String, dynamic>? colorJson) {
      if (colorJson == null) return null;

      final r = colorJson['r'] as int?;
      final g = colorJson['g'] as int?;
      final b = colorJson['b'] as int?;

      if (r != null && g != null && b != null) {
        return Color.fromARGB(255, r, g, b);
      }
      return null;
    }

    return LampState(
      state: json['state'] as String?,
      status: json['status'] as String?,
      hue: json['hue'] as int?,
      saturation: json['saturation'] as int?,
      kelvin: json['kelvin'] as int?,
      temperature: json['temperature'] as int?, // Alias for kelvin
      colorTemp: json['color_temp'] as int?,
      mode: json['mode'] as int?,
      level: json['level'] as int?,
      brightness: json['brightness'] as int?,
      effect: json['effect'] as String?,
      transition: (json['transition'] as num?)?.toDouble(),
      color: parseColor(json['color'] as Map<String, dynamic>?),
    );
  }

  /// Override the toString method to provide a readable output of the object
  @override
  String toString() {
    return '''
      LampState(
        state: $state,
        status: $status,
        hue: $hue,
        saturation: $saturation,
        kelvin: $kelvin,
        temperature: $temperature,
        colorTemp: $colorTemp,
        mode: $mode,
        level: $level,
        brightness: $brightness,
        effect: $effect,
        transition: $transition,
        color: $color
      )''';
  }
}
