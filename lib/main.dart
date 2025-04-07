import 'package:flutter/material.dart';
import 'bireysel_ekrani.dart';
import 'pomodoro_ekrani.dart';
import 'analiz_ekrani.dart';
import 'aile_ekrani.dart'; // Aile ekranı burada

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zaman Yönetimi Uygulaması',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: AnaMenu(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AnaMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ChronoFlow'a Hoş Geldin Serkan!")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Bugün ne yapmak istersin?", style: TextStyle(fontSize: 20)),
            SizedBox(height: 30),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              children: [
                _anaButon(
                  context,
                  "Bireysel Planlama",
                  Icons.person,
                  BireyselEkrani(),
                ),
                _anaButon(
                  context,
                  "Pomodoro Tekniği",
                  Icons.timer,
                  PomodoroEkrani(),
                ),
                _anaButon(
                  context,
                  "Analiz",
                  Icons.bar_chart,
                  AnalizEkrani(),
                ),
                _anaButon(
                  context,
                  "Aile Planlaması",
                  Icons.family_restroom,
                  AileEkrani(), // Burada doğrudan çağrılıyor
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _anaButon(BuildContext context, String baslik, IconData ikon, Widget ekran) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ekran),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(ikon, size: 48),
          SizedBox(height: 8),
          Text(baslik, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
