import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scanner_card_app/core/colors.dart';
import 'package:scanner_card_app/core/spaces.dart';
import 'package:scanner_card_app/models/document_model.dart';
import 'package:scanner_card_app/pages/detail_document_page.dart';
import 'package:scanner_card_app/datasources/document_local_datasource.dart';

class LatestDocumentsPage extends StatefulWidget {
  final List<DocumentModel> documents;
  const LatestDocumentsPage({
    super.key,
    required this.documents,
  });

  @override
  State<LatestDocumentsPage> createState() => _LatestDocumentsPageState();
}

class _LatestDocumentsPageState extends State<LatestDocumentsPage> {
  void _deleteDocument(DocumentModel document) async {
    await DocumentLocalDatasource.instance.deleteDocument(document);
    setState(() {
      widget.documents.remove(document);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.documents.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 3 / 2,
      ),
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey[200],
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailDocumentPage(
                    document: widget.documents[index],
                  ),
                ),
              );
            },
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      width: double.infinity,
                      File(widget.documents[index].path!),
                      fit: BoxFit.cover,
                      colorBlendMode: BlendMode.colorBurn,
                      color: AppColors.primary.withOpacity(0.2),
                    ),
                  ),
                ),
                const SpaceHeight(4),
                Text(
                  widget.documents[index].name!,
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                // IconButton(
                //   icon: Icon(Icons.delete, color: Colors.red),
                //   onPressed: () {
                //     _deleteDocument(widget.documents[index]);
                //   },
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}