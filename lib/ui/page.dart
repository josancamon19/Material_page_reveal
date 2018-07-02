import 'package:flutter/material.dart';

class Page extends StatefulWidget {
  final Color color;
  final String heroAssetPath;
  final String title;
  final String body;
  final String iconAssetIcon;
  final double percentVisible;

  Page(
      {this.color,
      this.heroAssetPath,
      this.title,
      this.body,
      this.iconAssetIcon,
      this.percentVisible});

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Page> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: widget.color,
      child: new Opacity(
        opacity: widget.percentVisible,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Transform(
              child: new Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Image.asset(
                  widget.heroAssetPath,
                  width: 200.0,
                  height: 200.0,
                ),
              ),
              transform: Matrix4.translationValues(
                  0.0, 50 * (1 - widget.percentVisible), 0.0),
            ),
            new Transform(
              child: new Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Text(
                  widget.title,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "FlamanteRoma",
                      fontSize: 34.0),
                ),
              ),
              transform: Matrix4.translationValues(
                  0.0, 30.0 - (1 - widget.percentVisible), 0.0),
            ),
            new Transform(
              child: new Padding(
                padding: const EdgeInsets.only(bottom: 80.0),
                child: Text(
                  widget.body,
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                  textAlign: TextAlign.center,
                ),
              ),
              transform: Matrix4.translationValues(
                  0.0, 30.0 - (1 - widget.percentVisible), 0.0),
            ),
          ],
        ),
      ),
    );
  }
}

final pages = [
  new Page(
    color: Color(0xFF678FB4),
    heroAssetPath: 'assets/hotels.png',
    title: 'Hotels',
    body: 'All hotels and hostels are sorted by hospitality rating',
    iconAssetIcon: 'assets/key.png',
  ),
  new Page(
    color: Color(0xFF65B0B4),
    heroAssetPath: 'assets/banks.png',
    title: 'Banks',
    body: 'We carefully verify all banks before adding them into the app',
    iconAssetIcon: 'assets/wallet.png',
  ),
  new Page(
    color: Color(0xFF9B90BC),
    heroAssetPath: 'assets/stores.png',
    title: 'Store',
    body: 'All local stores are categorized for your convenience',
    iconAssetIcon: 'assets/shopping_cart.png',
  ),
];
