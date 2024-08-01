import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path/path.dart' as path;
import 'package:vazifa_9/data/model/skills_model.dart';
import 'package:vazifa_9/ui/screen/academic_screen.dart';
import 'package:vazifa_9/ui/screen/experience_screen.dart';
import 'package:vazifa_9/ui/screen/summary_screen.dart';
import 'package:vazifa_9/ui/widget/custom_drawer_widget.dart';

class SkillsScreen extends StatefulWidget {
  const SkillsScreen({super.key});

  @override
  State<SkillsScreen> createState() => _SkillsScreenState();
}

class _SkillsScreenState extends State<SkillsScreen> {
  final List<SkillsInfo> skillsList = [
    SkillsInfo(
      imageFile: 'assets/images/ps.png',
      title: 'Adobe Photoshop',
    ),
    SkillsInfo(
      imageFile: 'assets/images/ai.png',
      title: 'Adobe Illustrator',
    ),
    SkillsInfo(
      imageFile: 'assets/images/id.png',
      title: 'Adobe InDesign',
    ),
    SkillsInfo(
      imageFile: 'assets/images/ae.png',
      title: 'Adobe After Effects',
    ),
    SkillsInfo(
      imageFile: 'assets/images/figma.png',
      title: 'Figma',
    ),
    SkillsInfo(
      imageFile: 'assets/images/html5.png',
      title: 'HTML5',
    ),
    SkillsInfo(
      imageFile: 'assets/images/css3.png',
      title: 'CSS3',
    ),
    SkillsInfo(
      imageFile: 'assets/images/js.png',
      title: 'JavaScript',
    ),
    SkillsInfo(
      imageFile: 'assets/images/vscode.png',
      title: 'VS Code',
    ),
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

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Skills',
                style:
                    pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            ...skillsList.map((skill) {
              return pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 10),
                child: pw.Row(
                  children: [
                    pw.Container(
                      width: 50,
                      height: 50,
                      child: pw.Image(pw.MemoryImage(
                          File(skill.imageFile).readAsBytesSync())),
                    ),
                    pw.SizedBox(width: 10),
                    pw.Text(skill.title,
                        style: pw.TextStyle(
                            fontSize: 18, fontWeight: pw.FontWeight.bold)),
                  ],
                ),
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
      SnackBar(content: Text('PDF saved to $outputFile')),
    );
  }

  Future<String> _getOutputFile() async {
    final directory = await getExternalStorageDirectory();
    final documentsDirectory =
        Directory(path.join(directory!.path, 'Documents'));

    if (!await documentsDirectory.exists()) {
      await documentsDirectory.create(recursive: true);
    }

    final filePath = path.join(documentsDirectory.path, 'summary.pdf');
    return filePath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawerWidget(),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: _generatePdf,
            icon: Icon(Icons.picture_as_pdf_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: skillsList.length,
              itemBuilder: (context, index) {
                final skill = skillsList[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Image.asset(skill.imageFile, width: 50, height: 50),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          skill.title,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
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
                onTap: () {},
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
                    child: Icon(Icons.arrow_forward, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
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
