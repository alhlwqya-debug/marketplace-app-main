extension StringExtensions on String {
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String get toTitleCase {
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  bool get isValidEmail {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(this);
  }

  bool get isValidPhone {
    final regex = RegExp(r'^05\d{8}$');
    return regex.hasMatch(this);
  }

  String get removeSpaces => replaceAll(' ', '');

  String get trimAndLower => trim().toLowerCase();
}
