import 'dart:io'; // For file operations.
import 'package:flutter/material.dart'; // Core Flutter UI components.
import 'package:file_picker/file_picker.dart'; // For picking files from the device.
import 'package:open_file/open_file.dart'; // To open files in external apps.
import 'package:path_provider/path_provider.dart'; // For accessing device directories.

import 'files_page.dart'; // Separate page for displaying multiple files.

void main() {
  runApp(const MyApp());
}

// Main widget of the app.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, // Hides the debug banner.
      home: FilePickerApp(), // Sets the home screen of the app.
    );
  }
}

// Stateful widget for the file picker app.
class FilePickerApp extends StatefulWidget {
  const FilePickerApp({super.key});

  @override
  State<FilePickerApp> createState() => _FilePickerAppState();
}

// The state class where the file picker logic resides.
class _FilePickerAppState extends State<FilePickerApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent, // AppBar color.
        title: const Text(
          "File Picker", // AppBar title text.
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 3, // Adds shadow effect to the AppBar.
        shadowColor: Colors.black, // Color of the shadow.
        centerTitle: true, // Centers the title text.
      ),
      body: Container(
        padding: const EdgeInsets.all(32), // Adds padding around the body.
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Center elements vertically.
          children: [
            // Button to pick a single file.
            ElevatedButton(
              onPressed: () async {
                final result = await FilePicker.platform.pickFiles();
                if (result == null) return; // If no file is picked, return.

                final file = result.files.first; // Get the first selected file.
                openFile(file); // Open the selected file.

                final newFile = await saveFilePermanently(
                    file); // Save the file permanently.
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10), // Rounded button corners.
                ),
                backgroundColor: Colors.indigoAccent, // Button color.
                minimumSize: const Size(400, 50), // Button size.
              ),
              child: const Text(
                "Pick File", // Button text.
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
            const SizedBox(
              height: 20, // Adds space between buttons.
            ),
            // Button to pick multiple files.
            ElevatedButton(
              onPressed: () async {
                final result = await FilePicker.platform.pickFiles(
                  allowMultiple: true, // Allows multiple file selection.
                  type: FileType.any, // Allows any file type.
                  // allowedExtensions: ['pdf', 'mp4'], // Uncomment to allow specific extensions.
                );
                if (result == null) return; // If no files are picked, return.
                openFiles(result.files); // Open all selected files.
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10), // Rounded button corners.
                ),
                backgroundColor: Colors.indigoAccent, // Button color.
                minimumSize: const Size(400, 50), // Button size.
              ),
              child: const Text(
                "Pick Multiple Files", // Button text.
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to open a single file using an external app.
  void openFile(PlatformFile file) {
    OpenFile.open(file.path); // Opens the file using its path.
  }

  // Function to save the selected file to a permanent location.
  Future<File> saveFilePermanently(PlatformFile file) async {
    final appStorage =
        await getApplicationDocumentsDirectory(); // Get the app's document directory.
    final newFile =
        File('${appStorage.path}/${file.name}'); // Create a new file path.
    return File(file.path!)
        .copy(newFile.path); // Copy the selected file to the new path.
  }

  // Function to open multiple files in a new screen.
  void openFiles(List<PlatformFile> files) => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => FilesPage(
            files: files, // Pass the list of selected files.
            onOpenedFile: openFile, // Callback to open a file.
          ),
        ),
      );
}
