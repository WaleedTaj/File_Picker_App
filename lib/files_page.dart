import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

// Stateful widget to display and interact with a list of files.
class FilesPage extends StatefulWidget {
  final List<PlatformFile> files; // List of selected files.
  final ValueChanged<PlatformFile>
      onOpenedFile; // Callback to handle file opening.

  // Constructor to initialize files and the file open callback.
  const FilesPage({super.key, required this.files, required this.onOpenedFile});

  @override
  State<FilesPage> createState() => _FilesPageState();
}

class _FilesPageState extends State<FilesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
            color: Colors.white), // Sets color of the back icon.
        backgroundColor: Colors.indigoAccent, // AppBar color.
        title: const Text(
          "All Files", // Title displayed in the AppBar.
          style: TextStyle(
              color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
        ),
        elevation: 3, // Adds shadow to the AppBar.
        shadowColor: Colors.black, // Shadow color.
        centerTitle: true, // Centers the title.
      ),
      body: Center(
        // GridView to display files in a grid format.
        child: GridView.builder(
          padding: const EdgeInsets.all(16), // Adds padding around the grid.
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of columns in the grid.
            mainAxisSpacing: 8, // Vertical spacing between grid items.
            crossAxisSpacing: 8, // Horizontal spacing between grid items.
          ),
          itemCount: widget.files.length, // Total number of files.
          itemBuilder: (context, index) {
            final file =
                widget.files[index]; // Get the file at the current index.
            return buildFile(file); // Build the UI for each file.
          },
        ),
      ),
    );
  }

  // Widget to build a single file's display.
  Widget buildFile(PlatformFile file) {
    final kb = file.size / 1024; // File size in KB.
    final mb = kb / 1024; // File size in MB.
    final fileSize = mb >= 1
        ? '${mb.toStringAsFixed(2)} MB'
        : '${kb.toStringAsFixed(2)} KB'; // Display size in MB or KB.
    final extension =
        file.extension ?? 'none'; // Get file extension, default to 'none'.
    const color = Colors.indigoAccent; // File display color.

    return InkWell(
      // Handles tap on a file to open it.
      onTap: () => widget
          .onOpenedFile(file), // Calls the onOpenedFile callback when tapped.
      child: Container(
        padding: const EdgeInsets.all(8), // Adds padding around the file card.
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Aligns content to the start.
          children: [
            // Expanded widget to make the file icon occupy the available space.
            Expanded(
              child: Container(
                alignment: Alignment.center, // Centers the file extension text.
                width: double.infinity, // Makes the container take full width.
                decoration: BoxDecoration(
                  color: color, // Sets background color of the container.
                  borderRadius: BorderRadius.circular(12), // Rounded corners.
                ),
                child: Text(
                  '.$extension', // Displays the file extension.
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 8, // Adds space between the icon and the file name.
            ),
            Text(
              file.name, // Displays the file name.
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              overflow: TextOverflow
                  .ellipsis, // Truncates long file names with ellipsis.
            ),
            Text(
              fileSize, // Displays the file size (MB/KB).
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
