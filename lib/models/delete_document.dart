import 'dart:io';
import 'package:flutter/material.dart';
import 'package:scanner_card_app/datasources/document_local_datasource.dart';
import 'package:scanner_card_app/models/document_model.dart';

Future<void> deleteDocument(BuildContext context, DocumentModel document) async {
  try {
    // Konfirmasi sebelum menghapus
    bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Dokumen?'),
        content: const Text('Apakah Anda yakin ingin menghapus dokumen ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Hapus',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmDelete == true) {
      // Hapus dari SQLite
      await DocumentLocalDatasource.instance.deleteDocument(document);

      // Hapus file dari storage jika ada
      File file = File(document.path!);
      if (await file.exists()) {
        await file.delete();
      }

      // Tampilkan notifikasi
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dokumen berhasil dihapus')),
      );

      // Kembali ke halaman sebelumnya
      Navigator.pop(context);
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Gagal menghapus dokumen: $e')),
    );
  }
}
