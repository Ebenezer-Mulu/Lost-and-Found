import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       
        leading: Builder(builder: (context) {
          return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              });
        }),
      ),
      drawer: Drawer(
        backgroundColor: const Color.fromARGB(255, 51, 49, 49),
        child: Column(
          mainAxisAlignment: MainAxisAlignment
              .spaceBetween, // Align items at the top and bottom
          children: [
            Column(
              children: [
                DrawerHeader(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'lib/images/logo.png',
                      // color: Colors.amber,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 25.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.home,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Home",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 25.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.home,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Lost Item",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 25.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.home,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Found Items",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 25.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.settings,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Setting",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(left: 25.0, bottom: 16.0),
              child: ListTile(
                leading: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                title: Text(
                  "Logout",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Scaffold(
        backgroundColor: Colors.grey[300],
      ),
    );
  }
}












 //backgroundColor: Colors.transparent,
        // actions: [
        //   TextButton(
        //     style: ButtonStyle(
        //       foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
        //     ),
        //     onPressed: () {
        //       ;
        //     },
        //     child: Text('Lost Item'),
        //   ),
        //   TextButton(
        //     style: ButtonStyle(
        //       foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
        //     ),
        //     onPressed: () {
        //         Navigator.push(
        //         context,
        //         MaterialPageRoute(builder: (context) => FoundItems()),
        //       );
        //     },
        //     child: Text('Found Item'),
        //   ),
        //   TextButton(
        //     style: ButtonStyle(
        //       foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
        //     ),
        //     onPressed: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(builder: (context) => Users()),
        //       );
        //     },
        //     child: Text('Users'),
        //   ),
        //   IconButton(
        //     onPressed: signUserOut,
        //     icon: Icon(Icons.logout),
        //   ),
        // ],