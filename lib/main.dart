import 'package:flutter/material.dart';
import 'package:newsapp/style.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'article.dart';
import 'detail_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              primary: secondaryColor,
              onPrimary: Colors.white,
              textStyle: const TextStyle(),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(0),
                ),
              ),
            ),
          ),

          appBarTheme: AppBarTheme(elevation: 0),
          textTheme: myTextTheme,
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: primaryColor,
                onPrimary: Colors.black,
                secondary: secondaryColor,
              ),
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: NewsListPage.routeName,
        routes: {
          NewsListPage.routeName: (context) => const NewsListPage(),
          ArticleDetailPage.routeName: (context) => ArticleDetailPage(
                article: ModalRoute.of(context)?.settings.arguments as Article,
              ),
          ArticleWebView.routeName: (context) => ArticleWebView(
                url: ModalRoute.of(context)?.settings.arguments as String,
              )
        });
  }
}

class NewsListPage extends StatelessWidget {
  static const routeName = '/article_list';

  const NewsListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News App'),
      ),
      body: FutureBuilder<String>(
        future:
            DefaultAssetBundle.of(context).loadString('assets/articles.json'),
        builder: (context, snapshot) {
          final List<Article> articles = parseArticles(snapshot.data);
          return ListView.builder(
            itemCount: articles.length,
            itemBuilder: (context, index) {
              return _buildArticleItem(context, articles[index]);
            },
          );
        },
      ),
    );
  }
}

Widget _buildArticleItem(BuildContext context, Article article) {
  return ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    leading: Image.network(
      article.urlToImage,
      width: 100,
    ),
    title: Text(article.title),
    onTap: () {
      Navigator.pushNamed(context, ArticleDetailPage.routeName,
          arguments: article);
    },
    subtitle: Text(article.author),
  );
}
