📋 Uygulama Özeti
🧩 Ana Menü
Uygulama açıldığında sizi “ChronoFlow’a Hoş Geldin Serkan!” başlıklı bir ana ekran karşılar. Burada dört büyük buton vardır:

Bireysel Planlama

Pomodoro Tekniği

Analiz

Aile Planlaması

👨‍👩‍👧‍👦 Aile Planlaması Ekranı
Bu ekran; her çocuk için ayrı sekmelerden oluşan, eğlenceli bir görev yönetim sistemidir.

Sekmeler: Varsayılan olarak 3 çocuk tanımlıdır.

Görev Ekleme: Her çocuk için ayrı görev tanımlanabilir. Saat seçme özelliği mevcuttur.

Tamamlama: Görevler tamamlandı olarak işaretlenebilir.

Silme: Görevler silinebilir.

Yeni Çocuk Ekleme: Sekmelerin sonunda "+" ikonu ile yeni çocuk sekmesi oluşturulabilir.

Arka Plan: Çocuklara hitap eden renkli bir arka plan görseli bulunur (assets/background.png).
Proje Dosya Yapısı (Özet)
lib/
│
├── main.dart               ← Ana giriş ve yönlendirme ekranı
├── aile_ekrani.dart        ← Aile planlaması ekranı (bu projenin odak noktası)
├── bireysel_ekrani.dart    ← Bireysel planlama ekranı
├── pomodoro_ekrani.dart    ← Pomodoro tekniği ekranı
├── analiz_ekrani.dart      ← İstatistik/analiz ekranı

🧠 Notlar
Kodlar sade, anlaşılır ve yorumlu şekilde yazılmıştır.

Uygulama geliştirilmeye açıktır: ses ekleme, ödül sistemi, bildirimler vb.

Arka plan görseli assets/background.png klasörüne manuel olarak eklenmelidir.

📱 Aile Planlaması Zaman Yönetimi Uygulaması
Bu uygulama, bireysel ve aile planlamasını destekleyen, zaman yönetimi odaklı bir mobil uygulamadır. Flutter ile geliştirilmiştir. Özellikle aileler için çocuklara özel görev planlaması yapmayı kolaylaştıran bir ekran içerir.
🔧 Özellikler
🧩 Ana Menü
Uygulama açıldığında kullanıcıyı ana menü karşılar. Menüde şu dört bölüm bulunur:

✅ Bireysel Planlama

✅ Pomodoro Tekniği

✅ Analiz

✅ Aile Planlaması

Kullanıcı istediği bölüme tıklayarak o ekrana geçebilir.
👨‍👩‍👧‍👦 Aile Planlaması Ekranı (Odak Noktası)
Bu ekran sayesinde her çocuk için ayrı görev listeleri oluşturulabilir ve bu görevler yönetilebilir.

Yapılan Geliştirmeler:

📌 Varsayılan olarak 3 çocuk sekmesi tanımlandı (Çocuk 1, Çocuk 2, Çocuk 3).

➕ Sekmelerin sonunda yer alan "+" butonuna tıklayarak yeni çocuklar eklenebilir.

📝 Her çocuk için görev eklenebilir. Göreve saat atanabilir.

✅ Görevler tamamlandı olarak işaretlenebilir veya geri alınabilir.

🗑 Görevler tek tıklamayla silinebilir.

🌈 Arka plana assets/background.png görseli yerleştirilerek çocuklara hitap eden renkli bir görünüm sağlandı.

⚠️ Sekme ve içerik sayısı eşitlenerek TabBar ile TabBarView uyumu sağlandı (önemli hata giderildi).

🛠 Kodda StatefulWidget, TabController, AlertDialog, showTimePicker, ListView, Card, ListTile gibi yapılar kullanıldı.

🚀 Kurulum Talimatları
1.Projeyi klonlayın:
git clone https://github.com/kullaniciadi/proje-adi.git
cd proje-adi
2.Gerekli paketleri yükleyin:
flutter pub get
3.Assets klasörüne dikkat:
assets/background.png dosyasını eklemeyi unutmayın.

pubspec.yaml içinde şu tanım yapılmalı:
flutter:
  assets:
    - assets/background.png
4. Uygulamayı çalıştırın:
 flutter run

📂 Dosya Yapısı (Özet)
lib/
├── main.dart               ← Ana menü ve yönlendirme
├── aile_ekrani.dart        ← Aile Planlaması ekranı
├── bireysel_ekrani.dart    ← Bireysel Planlama ekranı
├── pomodoro_ekrani.dart    ← Pomodoro ekranı
├── analiz_ekrani.dart      ← İstatistik ve analiz

✨ Proje Notları
Uygulama sade ve kullanıcı dostu olacak şekilde tasarlanmıştır.

Geliştirmeye uygundur. İleride ödül sistemi, hatırlatıcı, ses efektleri gibi eklentiler yapılabilir.

Kodlar okunabilirlik ve düzen açısından optimize edilmiştir.

📬 Katkıda Bulunmak
Bu projeye katkıda bulunmak isterseniz, fork'layıp pull request gönderebilirsiniz.

📝 Bireysel Planlama Ekranı Özeti
🎯 Amaç:
Kullanıcının kendi kişisel görevlerini ekleyip düzenleyebileceği sade ve etkili bir planlama ekranı sunmak.
💡 Özellikler:
✅ 1. Görev Ekleme Butonu
"+ Yeni Görev Ekle" adlı büyük bir buton ekranın ortasında yer alır.

Bu butona tıklandığında kullanıcıdan görev bilgisi istenir.

✅ 2. Henüz Görev Yoksa Bilgi Mesajı
Eğer hiç görev yoksa ekranda şu mesaj gösterilir:
"Henüz görev eklenmedi"

Mesaj ve buton birlikte ortalanmış şekilde görünür.

✅ 3. Görev Ekleme Modalı
Kullanıcı görev başlığı ve açıklaması girer.

Saat seçimi zorunludur.

Modal kapatıldığında ekran eski haline döner.

Modal açıkken arka plan silinir, sadece modal görünür.
✅4. Birden Fazla Görev Ekleyebilme
Modal kapatılmadan arka arkaya görevler eklenebilir.

Görev eklendikten sonra modal açık kalır, sadece input temizlenir.

✅ 5. Görevleri Görüntüleme
Eklenen görevler ekranda sıralanır.

Görev kutuları sabit boyutludur (uzun yazılar kutuyu taşırmaz).

Göreve tıklandığında detaylı açıklama ve saat görünür.

✅ 6. Görev Sıralaması
Görevler hem saate hem dakikaya göre sıralanır (örnek: 10:15, 10:30, 11:00 gibi).

✅ 7. Görev Silme
Her görev kartında çöp kutusu simgesi vardır.

Tıklanınca görev listeden silinir.

✅ 8. Görevi Tamamlandı Olarak İşaretleme
Her görevde tik (✔️) butonu vardır.

Tıklandığında görev tamamlandı olarak işaretlenir.

Tekrar tıklanınca “tamamlanmamış” hâline döner.

✅ 9. Duyarlı (Responsive) Tasarım
Ekran boyutuna göre öğeler otomatik hizalanır.

Tüm cihazlarda düzgün görünüm sağlanır.

🛠 Kullanılan Yapılar:
StatefulWidget, setState

AlertDialog, TextField, TimePicker

ListView, Card, ListTile

DateTime ve TimeOfDay işlemleri

Dinamik liste yapıları (List ve Map)

🧠 Kazanımlar:
Kullanıcı etkileşimi odaklı sade ve etkili görev yönetim sistemi geliştirildi.

Modal form yapısı ve saat seçimi Flutter’da başarıyla entegre edildi.

Görevlerin durum takibi (aktif / tamamlandı) uygulandı.

⏱️ Pomodoro Tekniği Ekranı Özeti
🎯 Amaç:
Kullanıcının odaklanmasını artırmak için Pomodoro zaman yönetimi tekniğini uygulayabileceği sade ve etkili bir zamanlayıcı ekranı sunmak.

💡 Özellikler:
✅ 1. Ders Adı Girişi
Kullanıcı, çalıştığı konuyu yazabileceği bir metin kutusuna sahiptir.

Girilen ders adı ekranın üst kısmında ve zamanlayıcının üzerinde görünür.

Eğer ders adı girilmemişse "Ders: Henüz girilmedi" yazısı gösterilir.

✅ 2. Çalışma ve Mola Modu Seçimi
Kullanıcı, iki butonla modlar arasında geçiş yapabilir:

🟢 Çalışma (25 dakika)

🔵 Mola (5 dakika)

Seçilen moda göre sayaç doğru süreyi gösterir.

✅ 3. Zamanlayıcı
Geriye doğru sayan bir dakika-saniye gösterimi vardır.

Ekranda sade şekilde zaman görünür. 
✅ 4. Kontrol Butonları
▶️ Başlat: Sayaç çalışmaya başlar.

⏸️ Duraklat: Sayaç durur.

🔁 Sıfırla: Sayaç sıfırlanır ve seçilen moda göre tekrar başlatılabilir.

✅ 5. Ekranlar Arası Geçişte Sayaç Korunur
Uygulama başka ekrana geçse bile sayaç bozulmadan geri döner.

Sayaç uygulama minimize edilip açıldığında da doğru kalan süreyi gösterir.

✅ 6. SharedPreferences Kullanımı
Pomodoro süresi ve başlama zamanı cihazda saklanır.

Uygulama tamamen kapansa bile kullanıcı geri döndüğünde doğru kalan süre hesaplanır.

✅ 7. Günlük İstatistik Özeti
Ekranın alt kısmında:

Bugün başlığı

Altında: “X Pomodoro • Y dakika çalışma” şeklinde günlük çalışma özeti gösterilir.

Bu özet şık bir kart kutusu (Card) içinde büyük yazıyla görünür.

🛠 Kullanılan Yapılar:
StatefulWidget, Timer, setState

TextField, SharedPreferences, DateTime

ElevatedButton, Column, Card, Icon

mod seçimi için toggle yapısı

🧠 Kazanımlar:
Kullanıcı odaklı Pomodoro çalışma sistemi geliştirildi.

Ekran değişse veya uygulama kapansa bile sayaç doğru şekilde çalışmaya devam eder.

Günlük ilerleme verisi sade ve etkili şekilde kullanıcıya sunulur.