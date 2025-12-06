import 'package:flutter/material.dart';
import '../models/inventaris.dart';
import '../services/api_service.dart';
import 'inventaris_form_page.dart';

class InventarisDetailPage extends StatefulWidget {
  final Inventaris inventaris;

  const InventarisDetailPage({super.key, required this.inventaris});

  @override
  State<InventarisDetailPage> createState() => _InventarisDetailPageState();
}

class _InventarisDetailPageState extends State<InventarisDetailPage> {
  late Inventaris _inventaris;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _inventaris = widget.inventaris;
  }

  Future<void> _deleteInventaris() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text(
          'Apakah Anda yakin ingin menghapus "${_inventaris.nama}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isLoading = true);

      final result = await ApiService.deleteInventaris(_inventaris.id!);

      setState(() => _isLoading = false);

      if (result['success']) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message']),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message']),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _editInventaris() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InventarisFormPage(inventaris: _inventaris),
      ),
    );

    if (result == true) {
      // Reload data setelah edit
      try {
        final updated = await ApiService.getInventarisById(_inventaris.id!);
        setState(() {
          _inventaris = updated;
        });
      } catch (e) {
        // Jika gagal reload, kembali ke list
        if (mounted) {
          Navigator.pop(context, true);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Detail Inventaris SuperDaiva'),
        backgroundColor: Colors.grey[800],
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editInventaris,
            tooltip: 'Edit',
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _isLoading ? null : _deleteInventaris,
            tooltip: 'Hapus',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header Card with Icon
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Icons.computer,
                              size: 60,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _inventaris.nama,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Kategori: Komputer',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Detail Info Cards
                  _buildDetailCard(
                    icon: Icons.attach_money,
                    title: 'Harga',
                    value: _inventaris.hargaFormatted,
                    subtitle: 'per unit',
                  ),
                  const SizedBox(height: 12),

                  _buildDetailCard(
                    icon: Icons.inventory,
                    title: 'Jumlah Stok',
                    value: '${_inventaris.jumlah} unit',
                    subtitle: 'tersedia',
                  ),
                  const SizedBox(height: 12),

                  _buildDetailCard(
                    icon: Icons.calendar_today,
                    title: 'Tanggal Masuk',
                    value: _inventaris.tanggalMasuk,
                    subtitle: 'tanggal barang masuk',
                  ),
                  const SizedBox(height: 12),

                  _buildDetailCard(
                    icon: Icons.calculate,
                    title: 'Total Nilai',
                    value: _inventaris.totalNilaiFormatted,
                    subtitle:
                        '${_inventaris.jumlah} x ${_inventaris.hargaFormatted}',
                    isHighlighted: true,
                  ),
                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _editInventaris,
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[800],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _isLoading ? null : _deleteInventaris,
                          icon: const Icon(Icons.delete, color: Colors.red),
                          label: const Text(
                            'Hapus',
                            style: TextStyle(color: Colors.red),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.red),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    bool isHighlighted = false,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isHighlighted ? Colors.grey[800] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isHighlighted ? Colors.grey[700] : Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 28,
                color: isHighlighted ? Colors.white : Colors.grey[700],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: isHighlighted
                          ? Colors.grey[300]
                          : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isHighlighted ? Colors.white : Colors.grey[800],
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isHighlighted
                          ? Colors.grey[400]
                          : Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
