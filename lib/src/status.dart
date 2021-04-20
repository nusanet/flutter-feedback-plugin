/// States dari enum [Status].
enum Status {
  /// Screenshot berhasil diambil.
  success,

  /// Screenshot gagal diambil karena permission ditolak.
  denied,

  /// Screenshot gagal diambil karena si pengguna memiliki akses yang terbatas.
  /// Seperti ada batasan dari parental controls.
  /// *Ini hanya berlaku di iOS.
  restricted,

  /// Screenshot gagal diambil karena permission ditolak secara permanen.
  /// *Ini hanya berlaku di Android.
  permanentlyDenied,

  /// Screenshot berhasil diambil cuma nilai path-nya null.
  fileNotFound,

  /// Screenshot gagal diambil karena status permission-nya tidak diketahui.
  unknown,
}