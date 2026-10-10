import 'dart:io';

void main() {
  var files = [
    r'c:\Office Project\HomeFix\HOMEFIX\lib\screens\profile\contact_us_screen.dart',
    r'c:\Office Project\HomeFix\HOMEFIX\lib\screens\profile\privacy_policy_screen.dart',
    r'c:\Office Project\HomeFix\HOMEFIX\lib\screens\profile\terms_conditions_screen.dart',
    r'c:\Office Project\HomeFix\HOMEFIX\lib\screens\profile\about_us_screen.dart'
  ];

  for (var path in files) {
    var file = File(path);
    if (!file.existsSync()) continue;
    
    var content = file.readAsStringSync();
    
    // Decrease font sizes using regex to avoid cascading replacements
    content = content.replaceAllMapped(RegExp(r'fontSize:\s*([\d\.]+)'), (match) {
      double size = double.parse(match.group(1)!);
      if (size >= 24) return 'fontSize: ${size - 4}';
      if (size >= 20) return 'fontSize: ${size - 3}';
      if (size >= 16) return 'fontSize: ${size - 2}';
      if (size >= 14) return 'fontSize: ${size - 2}';
      if (size >= 12) return 'fontSize: ${size - 1}';
      return 'fontSize: ${size}';
    });
    
    file.writeAsStringSync(content);
    print('Updated font sizes in $path');
  }
}
