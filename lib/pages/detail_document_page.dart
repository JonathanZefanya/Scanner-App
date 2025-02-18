import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scanner_card_app/core/app_format.dart';
import 'package:scanner_card_app/core/colors.dart';
import 'package:scanner_card_app/core/spaces.dart';
import 'package:scanner_card_app/models/document_model.dart';
import 'package:scanner_card_app/models/unduh_gambar.dart';
import 'package:scanner_card_app/models/delete_document.dart';

class DetailDocumentPage extends StatefulWidget {
  final DocumentModel document;
  const DetailDocumentPage({
    super.key,
    required this.document,
  });

  @override
  State<DetailDocumentPage> createState() => _DetailDocumentPageState();
}

class _DetailDocumentPageState extends State<DetailDocumentPage> {
  bool isDownloading = false;
  void startDownload() async {
    setState(() {
      isDownloading = true;
    });

    await unduhGambar(context, widget.document.path!);

    setState(() {
      isDownloading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Document'),
        actions: [
          IconButton(
            onPressed: () => deleteDocument(context, widget.document),
            icon: const Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.document.name!,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              GestureDetector(
                onTap: isDownloading ? null : startDownload,
                child: const Icon(
                  Icons.download,
                  color: AppColors.primary,
                  size: 30,
                ),
              ),
            ],
          ),
          const SpaceHeight(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.document.category!,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: AppColors.primary,
                ),
              ),
              Text(
                AppFormat.date(widget.document.createdAt!),
                style: const TextStyle(
                  fontSize: 16.0,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SpaceHeight(12),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.file(
              width: double.infinity,
              File(widget.document.path!),
              fit: BoxFit.contain,
              colorBlendMode: BlendMode.colorBurn,
              color: AppColors.primary.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }
}
