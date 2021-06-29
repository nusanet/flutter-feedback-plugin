import 'package:flutter_feedback/localization/lookup_message.dart';

class IdMessage implements LookupMessage {
  @override
  String appreciation() {
    return 'Pujian';
  }

  @override
  String complain() {
    return 'Keluhan';
  }

  @override
  String delete() {
    return 'Hapus';
  }

  @override
  String deleteScreenshot() {
    return 'Hapus gambar';
  }

  @override
  String edit() {
    return 'Ubah';
  }

  @override
  String editScreenshot() {
    return 'Edit gambar';
  }

  @override
  String enterYourFeedback() {
    return 'Masukkan tanggapanmu ya';
  }

  @override
  String feedback() {
    return 'Berikan Feedback';
  }

  @override
  String info() {
    return 'Info';
  }

  @override
  String loading() {
    return 'Tunggu sebentar ya';
  }

  @override
  String login() {
    return 'Masuk';
  }

  @override
  String ok() {
    return 'Ok';
  }

  @override
  String pleaseLeaveYourFeedback() {
    return 'Masukkan tanggapanmu pada form dibawah ini ya';
  }

  @override
  String pleaseSelectFeedbackCategory() {
    return 'Kategori tanggapanmu belum dipilih ya';
  }

  @override
  String pleaseSelectYourFeedbackCategoryBelow() {
    return 'Pilih kategori tanggapanmu';
  }

  @override
  String refreshTokenExpired() {
    return 'Sesi kamu telah berakhir. Coba masuk lagi ya';
  }

  @override
  String screenshots() {
    return 'Lampiran Gambar';
  }

  @override
  String send() {
    return 'Kirim';
  }

  @override
  String suggestion() {
    return 'Saran';
  }

  @override
  String thankYouForTheFeedback() {
    return 'Terimakasih atas masukkannya ya';
  }

  @override
  String weWouldLikeYourFeedback() {
    return 'Kami sangat senang menerima tanggapanmu untuk meningkatkan aplikasi ini';
  }

  @override
  String whatIsYourOpinionOfThisPage() {
    return 'Apa pendapatmu mengenai halaman ini?';
  }

  @override
  String typeMessageHere() {
    return 'Masukkan tanggapanmu di sini';
  }

  @override
  String viewScreenshot() {
    return 'Lihat gambar';
  }
}
