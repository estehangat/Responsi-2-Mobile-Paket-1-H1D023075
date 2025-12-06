class Inventaris {
  final int? id;
  final String nama;
  final int harga;
  final int jumlah;
  final String tanggalMasuk;
  final int? userId;
  final String? createdAt;
  final String? updatedAt;

  Inventaris({
    this.id,
    required this.nama,
    required this.harga,
    required this.jumlah,
    required this.tanggalMasuk,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory Inventaris.fromJson(Map<String, dynamic> json) {
    return Inventaris(
      id: json['id'],
      nama: json['nama'],
      harga: json['harga'],
      jumlah: json['jumlah'],
      tanggalMasuk: json['tanggal_masuk'],
      userId: json['user_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'harga': harga,
      'jumlah': jumlah,
      'tanggal_masuk': tanggalMasuk,
    };
  }

  // Format harga ke Rupiah
  String get hargaFormatted {
    return 'Rp ${harga.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  // Total nilai inventaris
  int get totalNilai => harga * jumlah;

  String get totalNilaiFormatted {
    return 'Rp ${totalNilai.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }
}
