import 'package:flutter/material.dart';
import 'package:news_app/models/news_model.dart';
import 'package:news_app/repositories/news_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'news_detail_page.dart'; 

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  NewsService newsService = NewsService();
  List<News> newsList = [];
  bool isLoading = true;
  String _selectedLanguage = 'tr'; // Varsayılan dil Türkçe
  double _textSize = 16.0; // Varsayılan metin boyutu
  String _selectedCategory = 'general';

  @override
  void initState() {
    super.initState();
    _loadPreferencesAndFetchNews(); // Dil ve metin boyutu yüklendikten sonra haberler çekilecek
  }

  // `SharedPreferences`'tan dil ve metin boyutunu yükleyen ve haberleri getiren fonksiyon
  Future<void> _loadPreferencesAndFetchNews() async {
    await _loadTextSize();
    await _loadSelectedLanguage(); // Seçilen dili yükleyin
    await _loadSelectedCategory();
    await fetchNewsData(); // Haberleri yükleyin
  }

  // Seçilen dili `SharedPreferences`'tan yükleyen fonksiyon
  Future<void> _loadSelectedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('selectedLanguage') ?? 'tr'; // Varsayılan dil kodu Türkçe
    });
  }

  // Metin boyutunu `SharedPreferences`'tan yükleyen fonksiyon
  Future<void> _loadTextSize() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _textSize = prefs.getDouble('textSize') ?? 16.0; // Varsayılan metin boyutu 16.0
    });
  }

    Future<void> _loadSelectedCategory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedCategory = prefs.getString('selectedCategory') ?? 'general'; // Varsayılan kategori
    });
  }

  // Haberleri seçilen dil ve metin boyutuna göre API'den çeken fonksiyon
  Future<void> fetchNewsData() async {
    setState(() {
      isLoading = true; // Haberler yüklenmeye başlamadan önce yükleme göstergesi gösterilir
    });

    try {
      List<dynamic> newsData = await newsService.fetchNews(language: _selectedLanguage , category: _selectedCategory); // Dil parametresini kullanıyoruz
      setState(() {
        newsList = newsData.map((json) => News.fromJson(json)).toList();
        isLoading = false; // Yükleme tamamlandı
      });
    } catch (e) {
      print('Haberleri yüklerken hata oluştu: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark; 
    return Scaffold(
          appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/profile_picture.png'), // Profil resmini buraya ekleyin
            ),
            SizedBox(width: 10), // Resim ile metin arasına boşluk ekleyin
            Text(
              'Hoşgeldin Veysel 👋',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ), 
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : PageView.builder(
              itemCount: newsList.length,
              scrollDirection: Axis.horizontal,
              reverse: false, // Sağdan sola kaydırma için
              itemBuilder: (context, index) {
                var newsItem = newsList[index];
                 return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsDetailWebView(url: newsItem.url), // URL'i WebView'e geçirin
                      ),
                    );
                  },
                  child:  Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    margin: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (newsItem.image.isNotEmpty)
                          Image.network(
                            newsItem.image,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/default_image.png', // Varsayılan görsel
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              );
                            },
                          )
                        else
                          Image.asset(
                            'assets/default_image.png', // Varsayılan görsel
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                newsItem.title,
                                style: TextStyle(
                                  fontSize: _textSize + 2, // Başlık boyutu
                                  fontWeight: FontWeight.bold,
                                ),
                                   maxLines: _textSize > 18 ? 4 : null, // Metin boyutu büyükse en fazla 5 satır
                               overflow: _textSize > 18 ? TextOverflow.ellipsis : null, // Taşan metni kes
                              ),
                              SizedBox(height: 8),
                              Text(
                                newsItem.description,
                                style: TextStyle(fontSize: _textSize), // Açıklama boyutu
                                 maxLines: _textSize > 18 ? 3 : null, // Metin boyutu büyükse en fazla 5 satır
                                overflow: _textSize > 18 ? TextOverflow.ellipsis : null, // Taşan metni kes
                              
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Yazar: ${newsItem.author}',
                                style: TextStyle(
                                  fontSize: _textSize - 2, // Yazar metin boyutu
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey[600],
                                ),
                                 maxLines: _textSize > 22 ? 2 : null,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Yayınlanma Tarihi: ${newsItem.published}',
                                style: TextStyle(
                                  fontSize: _textSize - 2, // Yayınlanma tarihi metin boyutu
                                  color: Colors.grey[600],
                                ),
                                 maxLines: _textSize > 22 ? 2 : null,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                 );
              },
            ),
    );
  }
}
