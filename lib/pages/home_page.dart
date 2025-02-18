import 'package:flutter/material.dart';
import 'package:google_mlkit_document_scanner/google_mlkit_document_scanner.dart';
import 'package:scanner_card_app/core/colors.dart';
import 'package:scanner_card_app/core/spaces.dart';
import 'package:scanner_card_app/core/title_content.dart';
import 'package:scanner_card_app/datasources/document_local_datasource.dart';
import 'package:scanner_card_app/models/document_model.dart';
import 'package:scanner_card_app/pages/latest_documents.dart';
import 'package:scanner_card_app/pages/menu_categories.dart';
import 'package:scanner_card_app/pages/save_document_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<DocumentModel> documents = [];
  String? pathImage;

  loadData() async {
    documents = await DocumentLocalDatasource.instance.getAllDocuments();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> _refreshDocuments() async {
    await loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scanner Card App"),
        elevation: 2,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Scan Kartu / Dokumen',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SpaceHeight(8),
                ElevatedButton(
                    onPressed: () async {
                      DocumentScannerOptions documentOptions =
                          DocumentScannerOptions(
                        documentFormat: DocumentFormat.jpeg,
                        mode: ScannerMode.filter,
                        pageLimit: 1,
                        isGalleryImport: true,
                      );

                      final documentScanner =
                          DocumentScanner(options: documentOptions);
                      DocumentScanningResult result =
                          await documentScanner.scanDocument();
                      final images = result.images;

                      pathImage = images[0];
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SaveDocumentPage(
                                    pathImage: pathImage!,
                                  )));
                      loadData();
                    },
                    child: const Text('Scan Document')),
              ],
            ),
          ),
          const SpaceHeight(16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TitleContent(title: 'Categories', onSeeAllTap: () {}),
          ),
          const SpaceHeight(12),
          const MenuCategories(),
          const SpaceHeight(20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TitleContent(title: 'Lates Documents', onSeeAllTap: () {}),
          ),
          const SpaceHeight(12.0),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshDocuments,
              child: LatestDocumentsPage(
                documents: documents,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
