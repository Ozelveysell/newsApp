import 'package:flutter/material.dart';
import 'home_tab.dart';
import 'newspaper_tab.dart';
import 'settings_tab.dart';

class HomePage extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  HomePage({required this.isDarkMode, required this.onThemeChanged});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // Tema durumuna göre AppBar rengini belirleyelim
    final appBarColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.black // Karanlık modda siyah AppBar
        : Colors.white.withOpacity(0.8); // Açık modda hafif şeffaf beyaz AppBar

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'News App',
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white // Karanlık modda beyaz metin
                  : Colors.black, // Açık modda siyah metin
            ),
          ),
          backgroundColor: appBarColor, // Dinamik AppBar rengi
        ),
        body: TabBarView(
          children: [
            HomeTab(), // Ana sayfa arayüzünü çağırdık
            NewspaperTab(), // Gazete arayüzünü çağırdık
            SettingsTab(
              isDarkMode: widget.isDarkMode,
              onThemeChanged: widget.onThemeChanged, // Tema değişikliği fonksiyonunu ayarladık
            ),
          ],
        ),
        bottomNavigationBar: Container(
          margin: EdgeInsets.all(30.0), // TabBar'ı kenarlardan ayırmak için boşluk ekledik
          padding: EdgeInsets.all(4.0), // İçeriğe biraz boşluk verdik
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8), // Arka plan rengi ve şeffaflık
            borderRadius: BorderRadius.circular(30), // Kenarları ovalleştiriyoruz
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4), // Gölge efekti
              ),
            ],
          ),
          child: TabBar(
            labelColor: Colors.green,
            unselectedLabelColor: Colors.white,
            indicatorColor: Colors.transparent,
            tabs: [
              Tab(
                icon: Container(
                  padding: EdgeInsets.all(8), // İç boşluk
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black), // Siyah yuvarlak çerçeve
                  ),
                  child: Icon(Icons.home),
                ),
              ),
              Tab(
                icon: Container(
                  padding: EdgeInsets.all(8), // İç boşluk
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black), // Siyah yuvarlak çerçeve
                  ),
                  child: Icon(Icons.article),
                ),
              ),
              Tab(
                icon: Container(
                  padding: const EdgeInsets.all(8), // İç boşluk
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black), // Siyah yuvarlak çerçeve
                  ),
                  child: Icon(Icons.settings),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
