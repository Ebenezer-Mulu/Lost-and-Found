import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

import '../../components/button.dart';
import '../../components/data_fetch.dart';
import '../../read_data/get_find_items.dart';
import '../found_items/view_found_item.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // an animation controller with a duration
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Create a curved animation
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    // Start the animation
    _controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Center(
                child: Text(
                  "Welcome",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(200 - (200 * _animation.value), 0),
                    child: Text(
                      "Find|Retrieve|Discover|Reclaim|Reassure ",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 400,
              child: FutureBuilder<List<String>>(
                future: DataFetcher.getFoundDocIds(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      List<String> documentIds = snapshot.data!;
                      return ScrollSnapList(
                        itemBuilder: (context, index) {
                          String documentId = documentIds[index];
                          return _buildListItem(context, documentId);
                        },
                        itemCount: documentIds.length,
                        itemSize: 250,
                        onItemFocus: (int index) {},
                        dynamicItemSize: true,
                        scrollDirection: Axis.horizontal,
                      );
                    } else {
                      return const Text('No data available');
                    }
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            const SizedBox(height: 30),
            Button(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ViewFoundItem(),
                  ),
                );
              },
              text: "See More",
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, String documentId) {
    return SizedBox(
      width: 250,
      // height: 500,
      child: Card(
        elevation: 12,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: Column(
            children: [
              GetFoundItem(documentId: documentId),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
