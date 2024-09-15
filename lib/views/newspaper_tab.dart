import 'package:flutter/material.dart';
import 'package:news_app/models/news_model.dart';
import 'package:news_app/repositories/news_service.dart';
import 'package:news_app/views/news_detail_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewspaperTab extends StatefulWidget {
  @override
  _NewspaperTabState createState() => _NewspaperTabState();
}

class _NewspaperTabState extends State<NewspaperTab> {
  NewsService newsService = NewsService();
  List<News> newsList = [];
  bool isLoading = true;
  double _textSize = 16.0;
  String _selectedLanguage = "tr";
  String _selectedCategory = 'general';
  @override
  void initState() {
    super.initState();
    _loadPreferencesAndFetchNews();
  }
 Future<void> _loadPreferencesAndFetchNews() async {
    await _loadTextSize();
    await _loadSelectedLanguage(); // Seçilen dili yükleyin
    await _loadSelectedCategory();
    await fetchNewsData(); // Haberleri yükleyin
    
  }
  Future<void> _loadSelectedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('selectedLanguage') ?? "tr";
    });

  }

  Future<void> _loadTextSize() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _textSize = prefs.getDouble('textSize') ?? 16.0; // Varsayılan boyut 16.0
    });
  }
  Future<void> _loadSelectedCategory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedCategory = prefs.getString('selectedCategory') ?? 'general'; // Varsayılan kategori
    });
  }
  Future<void> fetchNewsData() async {
    try {
      List<dynamic> newsData = await newsService.fetchNews(language: _selectedLanguage, category: _selectedCategory);
      setState(() {
        newsList = newsData.map((json) => News.fromJson(json)).toList();
        isLoading = false;
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
    return Scaffold(
   
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: newsList.length,
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
                                  fontSize: _textSize + 2, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text(
                              newsItem.description,
                              style: TextStyle(fontSize: _textSize ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Yazar: ${newsItem.author}',
                              style: TextStyle(
                                fontSize: _textSize - 2,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Yayınlanma Tarihi: ${newsItem.published}',
                              style: TextStyle(
                                fontSize: _textSize - 2,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                  );
              },
            ),
    );
  }
}
