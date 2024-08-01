import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:vazifa_9/data/model/info_model.dart';
import 'package:vazifa_9/ui/screen/academic_screen.dart';
import 'package:vazifa_9/ui/screen/experience_screen.dart';
import 'package:vazifa_9/ui/screen/summary_screen.dart';
import 'package:vazifa_9/ui/widget/custom_drawer_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: source);

    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  final List<Info> infoList = [
    Info(description: 'Asadbek Xomidov Deschamps'),
    Info(description: 'UX/UI & Visual Designer'),
    Info(description: 'Front-end developer'),
    Info(description: 'Graphic Designer'),
    Info(description: 'Visual communicator'),
    Info(description: '+10 years experience'),
    Info(
        description: 'Uzbekiston, Tashkent, Tashkent shahri',
        icon: Icons.location_on),
  ];

  Future<void> _checkPermissions() async {
    final status = await Permission.storage.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Storage permission not granted')),
      );
    }
  }

  Future<void> _generatePdf() async {
    await _checkPermissions();

    final pdf = pw.Document();
    final pdfImage =
        _image != null ? pw.MemoryImage(_image!.readAsBytesSync()) : null;

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            if (pdfImage != null)
              pw.Image(
                pdfImage,
                width: 150,
                height: 150,
                fit: pw.BoxFit.contain,
              ),
            pw.SizedBox(height: 20),
            ...infoList.map((info) {
              return info.icon != null
                  ? pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Icon(
                          pw.IconData(
                            info.icon.codePoint,
                          ),
                          size: 16,
                        ),
                        pw.SizedBox(width: 5),
                        pw.Text(info.description),
                      ],
                    )
                  : pw.Text(
                      info.description,
                      style: pw.TextStyle(fontSize: 14),
                    );
            }).toList(),
          ],
        ),
      ),
    );

    final outputFile = await _getOutputFile();
    final file = File(outputFile);
    await file.writeAsBytes(await pdf.save());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('PDF saved to ${outputFile}')),
    );
  }

  Future<String> _getOutputFile() async {
    final directory = await getExternalStorageDirectory();
    final picturesDirectory = Directory(path.join(directory!.path, 'Pictures'));

    if (!await picturesDirectory.exists()) {
      await picturesDirectory.create(recursive: true);
    }

    final filePath = path.join(picturesDirectory.path, 'info.pdf');
    return filePath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      drawer: CustomDrawerWidget(),
      appBar: AppBar(
        actionsIconTheme: IconThemeData(
          size: 25,
          color: Colors.black,
        ),
        actions: [
          IconButton(
            onPressed: _generatePdf,
            icon: Icon(Icons.picture_as_pdf_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _image == null
                          ? Text('No image selected.')
                          : Container(
                              height: 250,
                              width: 250,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(150),
                                image: DecorationImage(
                                  image: FileImage(_image!),
                                  fit: BoxFit.cover,
                                ),
                                border:
                                    Border.all(color: Colors.white, width: 8),
                              ),
                            ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => _pickImage(ImageSource.camera),
                        child: Text('Camera'),
                      ),
                      TextButton(
                        onPressed: () => _pickImage(ImageSource.gallery),
                        child: Text('Gallery'),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: infoList.map((info) {
                      if (info.icon != null) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(info.icon, color: Colors.blue),
                            SizedBox(width: 5),
                            Text(
                              info.description,
                              style: TextStyle(fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        );
                      }
                      return Text(
                        info.description,
                        style: TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            color: Colors.pink.shade200,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                              color: Colors.white,
                              width: 3,
                            ),
                          ),
                          child: Center(
                            child: Icon(Icons.arrow_back),
                          ),
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Container(
                          height: 45,
                          width: 120,
                          decoration: BoxDecoration(
                            color: Colors.pink.shade200,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Colors.blue.shade900,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Contact',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue.shade900,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => SummaryScreen()));
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            color: Colors.pink.shade200,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: Center(
                            child:
                                Icon(Icons.arrow_forward, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 60,
        color: Colors.blue[900],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.flash_on, color: Colors.white),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (ctx) => SummaryScreen()));
              },
            ),
            IconButton(
              icon: Icon(Icons.school, color: Colors.white),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (ctx) => AcademicScreen()));
              },
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward, color: Colors.white),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (ctx) => ExperienceScreen()));
              },
            ),
            IconButton(
              icon: Icon(Icons.settings, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.chat, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
