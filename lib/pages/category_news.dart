import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Market Cap'),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 2,
                      blurRadius: 2,
                    )
                  ],
                ),
                child: Text(
                  'USD',
                  style: TextStyle(color: Colors.black),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
