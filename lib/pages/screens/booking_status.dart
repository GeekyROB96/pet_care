import 'package:flutter/material.dart';

class StatusPage extends StatelessWidget {
  final List<String> tabTitles = [
    'Request',
    'Ongoing',
    'Accepted',
    'Rejected',
    'Completed'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookings'),
        centerTitle: true,
      ),
      body: DefaultTabController(
        length: tabTitles.length,
        child: Column(
          children: [
            Container(
              constraints: BoxConstraints.expand(height: 50),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.withOpacity(0.5),
                    width: 1.0,
                  ),
                ),
              ),
              child: TabBar(
                isScrollable: true,
                tabs: tabTitles.map((title) => Tab(text: title)).toList(),
                labelColor: Colors.deepPurple,
                unselectedLabelColor: Colors.black,
                indicator: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.deepPurpleAccent,
                      width: 3.0,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Container(
                    color: Colors.white,
                    child: Center(
                      child: Text('Requests'),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: Center(
                      child: Text('Ongoing'),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: Center(
                      child: Text('Accepted'),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: Center(
                      child: Text('Rejected'),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: Center(
                      child: Text('Completed'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
