import 'package:flutter/material.dart';

class AileEkrani extends StatefulWidget {
  @override
  _AileEkraniState createState() => _AileEkraniState();
}

class Gorev {
  final String icerik;
  TimeOfDay? saat;
  bool tamamlandi;

  Gorev({required this.icerik, this.saat, this.tamamlandi = false});
}

class _AileEkraniState extends State<AileEkrani> with TickerProviderStateMixin {
  List<String> cocuklar = ['Çocuk 1', 'Çocuk 2', 'Çocuk 3'];
  Map<String, List<Gorev>> gorevler = {
    'Çocuk 1': [],
    'Çocuk 2': [],
    'Çocuk 3': [],
  };

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: cocuklar.length + 1, vsync: this);
  }

  void cocukEkle() {
    TextEditingController isimController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Yeni Çocuk Ekle"),
        content: TextField(
          controller: isimController,
          decoration: InputDecoration(hintText: "Çocuğun adı"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("İptal"),
          ),
          ElevatedButton(
            onPressed: () {
              final isim = isimController.text.trim();
              if (isim.isNotEmpty) {
                setState(() {
                  cocuklar.add(isim);
                  gorevler[isim] = [];
                  _tabController = TabController(length: cocuklar.length + 1, vsync: this);
                });
              }
              Navigator.pop(context);
            },
            child: Text("Ekle"),
          ),
        ],
      ),
    );
  }

  void gorevEkle(String cocuk) {
    TextEditingController gorevController = TextEditingController();
    TimeOfDay? secilenSaat;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("$cocuk için Görev Ekle"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: gorevController,
              decoration: InputDecoration(hintText: "Görev girin"),
            ),
            SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () async {
                final TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (picked != null) {
                  setState(() {
                    secilenSaat = picked;
                  });
                }
              },
              icon: Icon(Icons.access_time),
              label: Text("Saat Seç"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("İptal"),
          ),
          ElevatedButton(
            onPressed: () {
              final icerik = gorevController.text.trim();
              if (icerik.isNotEmpty) {
                setState(() {
                  gorevler[cocuk]?.add(Gorev(icerik: icerik, saat: secilenSaat));
                });
              }
              Navigator.pop(context);
            },
            child: Text("Ekle"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: cocuklar.length + 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Çocuk Planlaması"),
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            onTap: (index) {
              if (index == cocuklar.length) {
                cocukEkle();
              }
            },
            tabs: [
              ...cocuklar.map((c) => Tab(text: c)).toList(),
              Tab(icon: Icon(Icons.add)),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            ...cocuklar.map((cocuk) {
              final gorevListesi = gorevler[cocuk]!;
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/background.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: ListView(
                  padding: EdgeInsets.all(16),
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => gorevEkle(cocuk),
                      icon: Icon(Icons.add),
                      label: Text("Yeni Görev Ekle"),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        textStyle: TextStyle(fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 20),
                    ...gorevListesi.asMap().entries.map((entry) {
                      final index = entry.key;
                      final gorev = entry.value;
                      return Card(
                        child: ListTile(
                          leading: IconButton(
                            icon: Icon(
                              gorev.tamamlandi ? Icons.check_circle : Icons.radio_button_unchecked,
                              color: gorev.tamamlandi ? Colors.green : null,
                            ),
                            onPressed: () {
                              setState(() {
                                gorev.tamamlandi = !gorev.tamamlandi;
                              });
                            },
                          ),
                          title: Text(
                            gorev.icerik,
                            style: TextStyle(
                              decoration: gorev.tamamlandi ? TextDecoration.lineThrough : null,
                            ),
                          ),
                          subtitle: gorev.saat != null
                              ? Text("Saat: ${gorev.saat!.format(context)}")
                              : null,
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                gorevListesi.removeAt(index);
                              });
                            },
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              );
            }),
            Center(
              child: Text(
                "Yeni çocuk eklemek için '+' sekmesine tıkla",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
