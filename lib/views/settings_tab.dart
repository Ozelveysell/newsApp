import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsTab extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  SettingsTab({required this.isDarkMode, required this.onThemeChanged});

  @override
  _SettingsTabState createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  late bool _isDarkMode;
  double _textSize = 16.0;
  bool _enableNotifications = true;
  String _selectedCategory = 'general';
  String _updateFrequency = 'Günlük';
  String _selectedLanguage = 'tr';

  final Map<String, String> _languageMap = {
    'Arapça': 'ar',
    'Almanca': 'de',
    'İngilizce': 'en',
    'İspanyolca': 'es',
    'Fransızca': 'fr',
    'İbranice': 'he',
    'İtalyanca': 'it',
    'Felemenkçe': 'nl',
    'Norveççe': 'no',
    'Portekizce': 'pt',
    'Rusça': 'ru',
    'İsveççe': 'se',
    'Çince': 'zh',
    'Japonca': 'ja',
    'Korece': 'ko',
    'Katalanca': 'ca',
    'Fince': 'fi',
    'Türkçe': 'tr',
  };

  final Map<String, String> _reverseLanguageMap = {
    'ar': 'Arapça',
    'de': 'Almanca',
    'en': 'İngilizce',
    'es': 'İspanyolca',
    'fr': 'Fransızca',
    'he': 'İbranice',
    'it': 'İtalyanca',
    'nl': 'Felemenkçe',
    'no': 'Norveççe',
    'pt': 'Portekizce',
    'ru': 'Rusça',
    'se': 'İsveççe',
    'zh': 'Çince',
    'ja': 'Japonca',
    'ko': 'Korece',
    'ca': 'Katalanca',
    'fi': 'Fince',
    'tr': 'Türkçe',
  };

    // Currents API kategorileri
  final Map<String, String> categoryMap = {
    'Genel': 'general',
    'Bilim': 'science',
    'Spor': 'sports',
    'İş Dünyası': 'business',
    'Eğlence': 'entertainment',
    'Sağlık': 'health',
    'Politika': 'politics',
    'Teknoloji': 'technology',
    'Dünya': 'world',
    'Bölgesel': 'regional',
  };

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
    _loadPreferences();
  }

  Future<void> _saveTextSize(double size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('textSize', size);
  }

  Future<void> _saveSelectedLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', languageCode);
    print(languageCode);
  }
   Future<void> _saveSelectedCategory(String categoryCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedCategory', categoryCode);
    print(categoryCode);
  }


  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _textSize = prefs.getDouble('textSize') ?? 16.0;
      _selectedLanguage = prefs.getString('selectedLanguage') ?? 'tr';
      _selectedCategory = prefs.getString('selectedCategory') ?? 'general';

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Karanlık Mod Kartı
            _buildCard(
              title: 'Karanlık Mod',
              icon: Icons.dark_mode,
              trailing: Switch(
                value: _isDarkMode,
                onChanged: (value) {
                  setState(() {
                    _isDarkMode = value;
                  });
                  widget.onThemeChanged(value);
                },
              ),
            ),
            SizedBox(height: 16),
            // Metin Boyutu Kartı
            _buildCard(
              title: 'Metin Boyutu',
              icon: Icons.text_fields,
              content: Column(
                children: [
                  Slider(
                    min: 12.0,
                    max: 24.0,
                    divisions: 6,
                    label: _textSize.toString(),
                    value: _textSize,
                    onChanged: (value) {
                      setState(() {
                        _textSize = value;
                      });
                      _saveTextSize(value);
                    },
                  ),
                  Text(
                    'Seçilen Metin Boyutu: ${_textSize.toInt()}',
                    style: TextStyle(fontSize: _textSize),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            // Bildirim Ayarları Kartı
            _buildCard(
              title: 'Bildirimleri Aç',
              icon: Icons.notifications_active,
              trailing: Switch(
                value: _enableNotifications,
                onChanged: (value) {
                  setState(() {
                    _enableNotifications = value;
                  });
                },
              ),
            ),
            SizedBox(height: 16),
            // Kategori Seçimi Kartı
             _buildCard(
              title: 'Kategori Tercihi',
              icon: Icons.category,
              content: DropdownButton<String>(
                value: categoryMap.entries
                    .firstWhere((entry) => entry.value == _selectedCategory)
                    .key,
                onChanged: (String? newValue) {
                  String categoryCode = categoryMap[newValue!]!;
                  setState(() {
                    _selectedCategory = categoryCode;
                  });
                  _saveSelectedCategory(categoryCode);
                },
                items: categoryMap.keys.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 16),
            // Dil Seçimi Kartı
            _buildCard(
              title: 'Dil Seçimi',
              icon: Icons.language,
              content: DropdownButton<String>(
                value: _reverseLanguageMap[_selectedLanguage],
                onChanged: (String? newLanguage) {
                  String languageCode = _languageMap[newLanguage!]!;
                  setState(() {
                    _selectedLanguage = languageCode;
                  });
                  _saveSelectedLanguage(languageCode);
                },
                items: _languageMap.keys.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 16),
            // İçerik Güncelleme Sıklığı Kartı
            _buildCard(
              title: 'İçerik Güncelleme Sıklığı',
              icon: Icons.update,
              content: DropdownButton<String>(
                value: _updateFrequency,
                onChanged: (String? newValue) {
                  setState(() {
                    _updateFrequency = newValue!;
                  });
                },
                items: <String>['Anlık', 'Saatlik', 'Günlük', 'Haftalık']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required IconData icon, Widget? content, Widget? trailing}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blueGrey[900], size: 28),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                if (trailing != null) trailing,
              ],
            ),
            if (content != null) ...[
              SizedBox(height: 16),
              content,
            ],
          ],
        ),
      ),
    );
  }
}
