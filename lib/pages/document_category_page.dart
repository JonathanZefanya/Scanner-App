import 'package:flutter/material.dart';
import 'package:scanner_card_app/datasources/document_local_datasource.dart';
import 'package:scanner_card_app/models/document_model.dart';
import 'package:scanner_card_app/pages/latest_documents.dart';


class DocumentCategoryPage extends StatefulWidget {
  final String categoryTitle;
  const DocumentCategoryPage({
    super.key,
    required this.categoryTitle,
  });

  @override
  State<DocumentCategoryPage> createState() => _DocumentCategoryPageState();
}

class _DocumentCategoryPageState extends State<DocumentCategoryPage> {
  List<DocumentModel> documents = [];

  loadData() async {
    documents = await DocumentLocalDatasource.instance
        .getDocumentByCategory(widget.categoryTitle);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Document ${widget.categoryTitle}'),
      ),
      body: Column(
        children: [
          Expanded(
              child: LatestDocumentsPage(
            documents: documents,
          )),
        ],
      ),
    );
  }
}
