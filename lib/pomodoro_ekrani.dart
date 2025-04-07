import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class PomodoroEkrani extends StatefulWidget {
  @override
  State<PomodoroEkrani> createState() => _PomodoroEkraniState();
}

class _PomodoroEkraniState extends State<PomodoroEkrani>
    with WidgetsBindingObserver {
  static const int odakSuresi = 60; // Test için 1 dakika
  static const int molaSuresi = 30; // Test için 30 saniye

  bool odakModu = true;
  bool calisiyorMu = false;
  Timer? zamanlayici;

  DateTime? baslangicZamani;
  int kalanSaniye = odakSuresi;

  int bugunPomodoro = 0;
  int bugunDakika = 0;

  TextEditingController dersController = TextEditingController();
  String dersAdi = "Henüz girilmedi";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _verileriYukle();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    zamanlayici?.cancel();
    dersController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _verileriYukle();
    } else if (state == AppLifecycleState.paused) {
      _verileriKaydet();
    }
  }

  Future<void> _verileriKaydet() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('odakModu', odakModu);
    prefs.setBool('calisiyorMu', calisiyorMu);
    prefs.setInt('bugunPomodoro', bugunPomodoro);
    prefs.setInt('bugunDakika', bugunDakika);
    if (calisiyorMu && baslangicZamani != null) {
      prefs.setInt('baslangicZamani', baslangicZamani!.millisecondsSinceEpoch);
      prefs.setInt('toplamSure', odakModu ? odakSuresi : molaSuresi);
    }
  }

  Future<void> _verileriYukle() async {
    final prefs = await SharedPreferences.getInstance();
    final kayitliBaslangic = prefs.getInt('baslangicZamani');
    final kayitliOdak = prefs.getBool('odakModu') ?? true;
    final kayitliCalisiyor = prefs.getBool('calisiyorMu') ?? false;
    final toplamSure = prefs.getInt('toplamSure') ?? (kayitliOdak ? odakSuresi : molaSuresi);

    final kayitliPomodoro = prefs.getInt('bugunPomodoro') ?? 0;
    final kayitliDakika = prefs.getInt('bugunDakika') ?? 0;

    int yeniKalan = toplamSure;

    if (kayitliBaslangic != null && kayitliCalisiyor) {
      final gecen = DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(kayitliBaslangic)).inSeconds;
      yeniKalan = toplamSure - gecen;
      if (yeniKalan < 0) yeniKalan = 0;
    }

    setState(() {
      odakModu = kayitliOdak;
      calisiyorMu = kayitliCalisiyor && yeniKalan > 0;
      kalanSaniye = yeniKalan;
      baslangicZamani = calisiyorMu ? DateTime.now().subtract(Duration(seconds: toplamSure - yeniKalan)) : null;
      bugunPomodoro = kayitliPomodoro;
      bugunDakika = kayitliDakika;
    });

    if (calisiyorMu && zamanlayici == null) {
      baslat();
    }
  }

  void baslat() {
    if (zamanlayici != null && zamanlayici!.isActive) return;

    baslangicZamani = DateTime.now();

    zamanlayici = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        kalanSaniye--;
        if (kalanSaniye <= 0) {
          zamanlayici?.cancel();
          zamanlayici = null;
          calisiyorMu = false;

          if (odakModu) {
            bugunPomodoro += 1;
            bugunDakika += 1;
          }

          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Zamanlayıcı"),
              content: Text(odakModu
                  ? "Odak süresi bitti! Şimdi mola zamanı."
                  : "Mola bitti! Hadi yeniden odaklan."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      odakModu = !odakModu;
                      kalanSaniye = odakModu ? odakSuresi : molaSuresi;
                      calisiyorMu = true;
                      baslangicZamani = DateTime.now();
                    });
                    baslat();
                  },
                  child: Text("Devam Et"),
                ),
              ],
            ),
          );
        }
      });

      _verileriKaydet();
    });

    setState(() {
      calisiyorMu = true;
    });
  }

  void durdur() {
    zamanlayici?.cancel();
    zamanlayici = null;
    setState(() {
      calisiyorMu = false;
      baslangicZamani = null;
    });
    _verileriKaydet();
  }

  void sifirla() {
    zamanlayici?.cancel();
    zamanlayici = null;
    setState(() {
      calisiyorMu = false;
      kalanSaniye = odakModu ? odakSuresi : molaSuresi;
      baslangicZamani = null;
    });
    _verileriKaydet();
  }

  String formatlaZaman(int saniye) {
    int dakika = saniye ~/ 60;
    int s = saniye % 60;
    return '${dakika.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pomodoro Tekniği")),
      backgroundColor: odakModu ? Colors.white : Color(0xFFE3F6F5),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: dersController,
                decoration: InputDecoration(
                  labelText: "Ders Adı Girin",
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    dersAdi = value.isEmpty ? "Henüz girilmedi" : value;
                  });
                },
              ),
              SizedBox(height: 16),
              Text(
                "Ders: $dersAdi",
                style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChoiceChip(
                    label: Text("Çalışma", style: TextStyle(fontSize: 22)),
                    selected: odakModu,
                    onSelected: (secildi) {
                      if (secildi) {
                        setState(() {
                          odakModu = true;
                          sifirla();
                        });
                      }
                    },
                  ),
                  SizedBox(width: 12),
                  ChoiceChip(
                    label: Text("Mola", style: TextStyle(fontSize: 22)),
                    selected: !odakModu,
                    onSelected: (secildi) {
                      if (secildi) {
                        setState(() {
                          odakModu = false;
                          sifirla();
                        });
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 32),
              Text(
                odakModu ? "Odaklanma Zamanı" : "Mola Zamanı",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                formatlaZaman(kalanSaniye),
                style: TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: calisiyorMu ? null : baslat,
                    icon: Icon(Icons.play_arrow),
                    label: Text("Başlat", style: TextStyle(fontSize: 18)),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: calisiyorMu ? durdur : null,
                    icon: Icon(Icons.pause),
                    label: Text("Durdur", style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: sifirla,
                    icon: Icon(Icons.replay),
                    label: Text("Sıfırla", style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                ],
              ),
              SizedBox(height: 36),
              Card(
  elevation: 6,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  ),
  margin: EdgeInsets.symmetric(vertical: 20),
  child: Padding(
    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Bugün",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text(
          "$bugunPomodoro Pomodoro • $bugunDakika dakika çalışma",
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey[800],
          ),
        ),
      ],
    ),
  ),
),

            ],
          ),
        ),
      ),
    );
  }
}
