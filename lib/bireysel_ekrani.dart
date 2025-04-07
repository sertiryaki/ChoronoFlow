import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Gorev {
  final TimeOfDay saat;
  final String baslik;
  final String aciklama;
  bool tamamlandi;
  bool detayAcik;

  Gorev({
    required this.saat,
    required this.baslik,
    required this.aciklama,
    this.tamamlandi = false,
    this.detayAcik = false,
  });
}

class BireyselEkrani extends StatefulWidget {
  @override
  _BireyselEkraniState createState() => _BireyselEkraniState();
}

class _BireyselEkraniState extends State<BireyselEkrani> {
  List<Gorev> gorevler = [];
  TimeOfDay? secilenSaat;
  TextEditingController baslikController = TextEditingController();
  TextEditingController aciklamaController = TextEditingController();
  bool gorevEklemeAcik = false;
  bool ilkGorevEklendi = false;

  @override
  void initState() {
    super.initState();
    gorevleriYukle();
  }

  void saatSec() async {
    final TimeOfDay? result = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (result != null) {
      setState(() {
        secilenSaat = result;
      });
    }
  }

  Future<void> gorevEkle() async {
    if (baslikController.text.isEmpty || secilenSaat == null) return;

    setState(() {
      gorevler.add(Gorev(
        saat: secilenSaat!,
        baslik: baslikController.text,
        aciklama: aciklamaController.text,
      ));

      gorevler.sort((a, b) =>
          (a.saat.hour * 60 + a.saat.minute).compareTo(b.saat.hour * 60 + b.saat.minute));

      baslikController.clear();
      aciklamaController.clear();
      secilenSaat = null;
      gorevEklemeAcik = false;
      ilkGorevEklendi = true;
    });

    await gorevleriKaydet();
  }

  Future<void> gorevSil(int index) async {
    setState(() {
      gorevler.removeAt(index);
    });
    await gorevleriKaydet();
  }

  Future<void> gorevTamamla(int index) async {
    setState(() {
      gorevler[index].tamamlandi = !gorevler[index].tamamlandi;
    });
    await gorevleriKaydet();
  }

  Future<void> gorevleriKaydet() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> jsonList = gorevler.map((g) => jsonEncode({
      'saat': '${g.saat.hour}:${g.saat.minute}',
      'baslik': g.baslik,
      'aciklama': g.aciklama,
      'tamamlandi': g.tamamlandi,
    })).toList();
    await prefs.setStringList('gorevler', jsonList);
  }

  Future<void> gorevleriYukle() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? jsonList = prefs.getStringList('gorevler');
    if (jsonList != null) {
      List<Gorev> yuklenen = jsonList.map((item) {
        final map = jsonDecode(item);
        final saatParcali = map['saat'].split(':');
        return Gorev(
          saat: TimeOfDay(
            hour: int.parse(saatParcali[0]),
            minute: int.parse(saatParcali[1])),
          baslik: map['baslik'],
          aciklama: map['aciklama'],
          tamamlandi: map['tamamlandi'],
        );
      }).toList();
      setState(() {
        gorevler = yuklenen;
      });
    }
  }

  Widget gorevKart(Gorev gorev, int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: gorev.tamamlandi ? Colors.green[100] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            gorev.detayAcik = !gorev.detayAcik;
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
  gorev.baslik,
  maxLines: gorev.detayAcik ? null : 1,
  overflow: gorev.detayAcik ? TextOverflow.visible : TextOverflow.ellipsis,
  style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    decoration: gorev.tamamlandi ? TextDecoration.lineThrough : null,
  ),
),

            if (gorev.detayAcik)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  gorev.aciklama,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    decoration: gorev.tamamlandi ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
            SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  gorev.saat.format(context),
                  style: TextStyle(color: Colors.blueGrey),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.check_circle,
                          color: gorev.tamamlandi ? Colors.orange : Colors.green),
                      onPressed: () => gorevTamamla(index),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => gorevSil(index),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget gorevEklemeModali() {
    return Center(
      child: SingleChildScrollView(
        child: Card(
          margin: EdgeInsets.only(top: 50, left: 24, right: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text("Yeni Görev Ekle", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                TextField(
                  controller: baslikController,
                  decoration: InputDecoration(
                    labelText: "Görev Başlığı",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: aciklamaController,
                  decoration: InputDecoration(
                    labelText: "Açıklama (İsteğe Bağlı)",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      secilenSaat != null
                          ? "Saat: ${secilenSaat!.format(context)}"
                          : "Saat seçilmedi",
                      style: TextStyle(fontSize: 16),
                    ),
                    Spacer(),
                    ElevatedButton(onPressed: saatSec, child: Text("Saat Seç")),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: gorevEkle,
                  style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50)),
                  child: Text("Kaydet"),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    setState(() {
                      gorevEklemeAcik = false;
                      baslikController.clear();
                      aciklamaController.clear();
                      secilenSaat = null;
                    });
                  },
                  child: Text("İptal"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Gorev> tamamlanmamis = gorevler.where((g) => !g.tamamlandi).toList();
    List<Gorev> tamamlanmis = gorevler.where((g) => g.tamamlandi).toList();

    return Scaffold(
      appBar: AppBar(title: Text("Bireysel Planlama")),
      body: Column(
        children: [
          if (gorevler.isEmpty && !gorevEklemeAcik)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: ilkGorevEklendi ? 320 : 260,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            gorevEklemeAcik = true;
                          });
                        },
                        icon: Icon(Icons.add, size: 30),
                        label: Text(
                          "Yeni Görev Ekle",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Henüz görev eklenmedi",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          if (gorevEklemeAcik) Expanded(child: gorevEklemeModali()),
          if (gorevler.isNotEmpty && !gorevEklemeAcik)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    gorevEklemeAcik = true;
                  });
                },
                icon: Icon(Icons.add, size: 26),
                label: Text("Yeni Görev Ekle", style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                ),
              ),
            ),
          if (gorevler.isNotEmpty)
            Expanded(
              child: ListView(
                children: [
                  if (tamamlanmamis.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: Text("Aktif Görevler", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ...tamamlanmamis
                      .asMap()
                      .entries
                      .map((e) => gorevKart(e.value, gorevler.indexOf(e.value))),
                  if (tamamlanmis.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: Text("Tamamlananlar", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ...tamamlanmis
                      .asMap()
                      .entries
                      .map((e) => gorevKart(e.value, gorevler.indexOf(e.value))),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
