import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/inventaris.dart';
import '../services/api_service.dart';

class InventarisFormPage extends StatefulWidget {
  final Inventaris? inventaris; // null untuk tambah, filled untuk edit

  const InventarisFormPage({super.key, this.inventaris});

  @override
  State<InventarisFormPage> createState() => _InventarisFormPageState();
}

class _InventarisFormPageState extends State<InventarisFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _hargaController = TextEditingController();
  final _jumlahController = TextEditingController();
  final _tanggalController = TextEditingController();
  bool _isLoading = false;
  DateTime? _selectedDate;

  bool get isEditMode => widget.inventaris != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      _namaController.text = widget.inventaris!.nama;
      _hargaController.text = widget.inventaris!.harga.toString();
      _jumlahController.text = widget.inventaris!.jumlah.toString();
      _tanggalController.text = widget.inventaris!.tanggalMasuk;

      // Parse tanggal
      try {
        _selectedDate = DateFormat(
          'yyyy-MM-dd',
        ).parse(widget.inventaris!.tanggalMasuk);
      } catch (e) {
        _selectedDate = DateTime.now();
      }
    } else {
      _selectedDate = DateTime.now();
      _tanggalController.text = DateFormat('yyyy-MM-dd').format(_selectedDate!);
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _hargaController.dispose();
    _jumlahController.dispose();
    _tanggalController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.grey[800]!,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.grey[800]!,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _tanggalController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _saveInventaris() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final inventaris = Inventaris(
        nama: _namaController.text.trim(),
        harga: int.parse(_hargaController.text),
        jumlah: int.parse(_jumlahController.text),
        tanggalMasuk: _tanggalController.text,
      );

      Map<String, dynamic> result;
      if (isEditMode) {
        result = await ApiService.updateInventaris(
          widget.inventaris!.id!,
          inventaris,
        );
      } else {
        result = await ApiService.createInventaris(inventaris);
      }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          isEditMode
              ? 'Edit Inventaris SuperDaiva'
              : 'Tambah Inventaris SuperDaiva',
        ),
        backgroundColor: Colors.grey[800],
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Icon Header
              Icon(
                isEditMode ? Icons.edit : Icons.add_box,
                size: 60,
                color: Colors.grey[700],
              ),
              const SizedBox(height: 8),
              Text(
                isEditMode ? 'Edit Data Komputer' : 'Tambah Data Komputer',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 32),

              // Nama Field
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(
                  labelText: 'Nama Barang',
                  hintText: 'Contoh: Laptop ASUS ROG',
                  prefixIcon: const Icon(Icons.computer),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama barang harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Harga Field
              TextFormField(
                controller: _hargaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Harga (Rp)',
                  hintText: 'Contoh: 15000000',
                  prefixIcon: const Icon(Icons.attach_money),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga harus diisi';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Harga harus berupa angka';
                  }
                  if (int.parse(value) <= 0) {
                    return 'Harga harus lebih dari 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Jumlah Field
              TextFormField(
                controller: _jumlahController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Jumlah',
                  hintText: 'Contoh: 10',
                  prefixIcon: const Icon(Icons.inventory),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jumlah harus diisi';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Jumlah harus berupa angka';
                  }
                  if (int.parse(value) <= 0) {
                    return 'Jumlah harus lebih dari 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Tanggal Masuk Field
              TextFormField(
                controller: _tanggalController,
                readOnly: true,
                onTap: _selectDate,
                decoration: InputDecoration(
                  labelText: 'Tanggal Masuk',
                  hintText: 'Pilih tanggal',
                  prefixIcon: const Icon(Icons.calendar_today),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.date_range),
                    onPressed: _selectDate,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tanggal masuk harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Save Button
              ElevatedButton(
                onPressed: _isLoading ? null : _saveInventaris,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[800],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : Text(
                        isEditMode ? 'Update' : 'Simpan',
                        style: const TextStyle(fontSize: 16),
                      ),
              ),
              const SizedBox(height: 12),

              // Cancel Button
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey[800],
                  side: BorderSide(color: Colors.grey[800]!),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Batal', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
