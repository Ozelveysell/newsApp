import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_app/models/news_model.dart';

class NewsService {
  final String apiKey = 'YOUR_API_KEY'; 
  final String apiUrl = 'https://api.currentsapi.services/v1/latest-news';

  // Her istekte 50 haber çeken fonksiyon
  Future<List<dynamic>> fetchNews({required String language, required String category ,int page = 1}) async {
    final response = await http.get(
      Uri.parse('$apiUrl?language=$language&category=$category&limit=50&page=$page'), // Limit parametresi ile her istekte 50 haber çekiyoruz
      headers: {
        'Authorization': apiKey, // API anahtarınızı header'a ekleyin.
      },
    );
//print(language);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
    //  print(jsonResponse['news']);
      return jsonResponse['news'];
    } else {
      throw Exception('Haberler yüklenemedi!');
    }
  }
  void parseNewsResponse(Map<String, dynamic> responseJson) {
  List<dynamic> newsJson = responseJson['news'];
  List<News> newsList = newsJson.map((json) => News.fromJson(json)).toList();

  // Şimdi haberleri `newsList` içinde saklayabilirsiniz.
  for (var news in newsList) {
    print(news.title); // Haber başlıklarını yazdırıyoruz
  }
}
}
