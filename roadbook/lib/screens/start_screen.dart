import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'roadbook_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});
  @override
  State<StartScreen> createState() => _StartScreen();
  /*Future<void> _pickGpxFile(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['gpx'],
    );
    if (result != null && result.files.single.path != null) {
      Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder:
              (_) => RoadbookScreen(gpxFilePath: result.files.single.path!),
        ),
      );
    }
  }*/
}

class _StartScreen extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("File Picker")),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _pickFile(context),
                child: Text("Pick File"),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  void _pickFile(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      //allowedExtensions: ['gpx'],
    );
    if (context.mounted) {
      if (result != null && result.files.single.path != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => RoadbookScreen(gpxFilePath: result.files.single.path!),
          ),
        );
      } else {
        /// User canceled the picker
      }
    }
  }
}
