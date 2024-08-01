import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vazifa_9/data/model/academic_model.dart';
import 'package:vazifa_9/ui/screen/experience_screen.dart';
import 'package:vazifa_9/ui/screen/skills_screen.dart';
import 'package:vazifa_9/ui/screen/summary_screen.dart';
import 'package:vazifa_9/ui/widget/custom_drawer_widget.dart';

class AcademicScreen extends StatefulWidget {
  const AcademicScreen({super.key});

  @override
  State<AcademicScreen> createState() => _AcademicScreenState();
}

class _AcademicScreenState extends State<AcademicScreen> {
  final List<AcademicInfo> academicInfoList = [
    AcademicInfo(
        level: 'GRADUATE',
        title: 'JOURNALISM',
        institution: 'Universidad Pontificia de Salamanca',
        year: '2007'),
    AcademicInfo(
        level: 'MASTER',
        title: 'GALICIAN LANG.',
        institution: 'Universidade da Coruña',
        year: '2009'),
    AcademicInfo(
        level: 'SUPERIOR TECNICIAN',
        title: 'WEB APP DEVELOPMENT',
        institution: 'IES Fernando Wirtz (A Coruña)',
        year: '2016'),
    AcademicInfo(
        level: 'SPECIALIZATION',
        title: 'UX/UI DESIGN',
        institution: 'La Zona - FUE (Fundación Universidad Empresa)',
        year: '2022'),
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

    // Add Academic Screen Data to PDF
    _addAcademicScreenData(pdf);

    // Save PDF to file
    final outputFile = await _getOutputFile();
    final file = File(outputFile);
    await file.writeAsBytes(await pdf.save());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('PDF saved to ${outputFile}')),
    );
  }

  void _addAcademicScreenData(pw.Document pdf) {
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: academicInfoList.map((academic) {
            return pw.Padding(
              padding: const pw.EdgeInsets.symmetric(vertical: 10),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Icon(
                    pw.IconData(0xe800), // Custom icon data
                    size: 32,
                  ),
                  pw.SizedBox(width: 16),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(academic.level,
                          style: pw.TextStyle(
                              fontSize: 14, fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 4),
                      pw.Text(academic.title,
                          style: pw.TextStyle(
                              fontSize: 18, fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 4),
                      pw.Text(academic.institution,
                          style: pw.TextStyle(fontSize: 14)),
                      pw.SizedBox(height: 4),
                      pw.Text('Year: ${academic.year}',
                          style: pw.TextStyle(
                              fontSize: 12, fontStyle: pw.FontStyle.italic)),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<String> _getOutputFile() async {
    final directory = await getExternalStorageDirectory();
    final academicDirectory =
        Directory(path.join(directory!.path, 'AcademicInfo'));

    if (!await academicDirectory.exists()) {
      await academicDirectory.create(recursive: true);
    }

    final filePath = path.join(academicDirectory.path, 'academic_info.pdf');
    return filePath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: Text('Academic Background'),
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
      drawer: CustomDrawerWidget(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: academicInfoList.length,
              itemBuilder: (context, index) {
                final academic = academicInfoList[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        academic.level,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        academic.title,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(academic.institution),
                      SizedBox(height: 4),
                      Text(
                        'Year: ${academic.year}',
                        style: TextStyle(
                            fontSize: 12, fontStyle: FontStyle.italic),
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
                onTap: () {
                  // Navigator.pushReplacement(context,
                  //     MaterialPageRoute(builder: (ctx) => SummaryScreen()));
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
              onPressed: () {},
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
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (ctx) => SkillsScreen()));
              },
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
