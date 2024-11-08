import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  final int _cardCount = 4; // Total number of unique cards

  @override
  void initState() {
    super.initState();
    // Automatically jump to the middle of the infinite list to simulate looping
    _pageController.addListener(() {
      int currentPage = _pageController.page!.round();
      if (currentPage == 0) {
        _pageController.jumpToPage(_cardCount * 100);
      } else if (currentPage == _cardCount * 200 - 1) {
        _pageController.jumpToPage(_cardCount * 100 - 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
        ),
        title: TextField(
          decoration: InputDecoration(
            hintText: "Search here",
            suffixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications,),
            onPressed: () {},
          ),
        ],
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Carousel Section with Reduced Gap and Looping Effect
            Container(
              height: 160,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _cardCount * 200, // Large number to create looping effect
                itemBuilder: (context, index) {
                  int displayIndex = index % _cardCount;
                  return _buildCarouselCard(displayIndex);
                },
              ),
            ),
            SizedBox(height: 20),
            // KYC Pending Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 23, 134, 226),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Text("KYC Pending", style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text("You need to provide the required documents for your account activation."),
                    SizedBox(height: 4),
                    TextButton(onPressed: () {}, child: Text("Click Here"))
                  ],
                ),
              ),
            ),
            // Category Icons in Circular Containers
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildCategoryIcon(Icons.phone, "Mobile",Colors.blue),
                  buildCategoryIcon(Icons.laptop, "Laptop",Colors.green),
                  buildCategoryIcon(Icons.camera_alt, "Camera",Colors.red[200]),
                  buildCategoryIcon(Icons.lightbulb, "LED",Colors.orange[400]),
                ],
              ),
            ),
            // Exclusive For You Section with Horizontal Scroll Product Cards
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("EXCLUSIVE FOR YOU", style: TextStyle(fontWeight: FontWeight.bold)),
                    Container(
                      height: 400,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          ProductCard(),
                          ProductCard(),
                          ProductCard(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text("Chat"),
        icon: Icon(Icons.chat),
        backgroundColor: Colors.red,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: "Categories"),
          BottomNavigationBarItem(icon: Icon(Icons.local_offer), label: "Deals"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  // Helper method to build each card in the carousel
  Widget _buildCarouselCard(int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5), // Reduced gap between cards
      decoration: BoxDecoration(
        color: Colors.blue, // Same color for all cards
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 4),
        ],
      ),
      child: Center(
        child: Text(
          "Card ${index + 1}",
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }

  // Helper method to build a category icon with circular container
  Widget buildCategoryIcon(IconData icon, String label,color) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
          child: Icon(icon, color: Colors.white),
        ),
        SizedBox(height: 4),
        Text(label),
      ],
    );
  }
}

// Sample product card widget
class ProductCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.grey, blurRadius: 2),
        ],
      ),
      child: Column(
        children: [
          Expanded(child: Placeholder()), // Replace with Image
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Product Name"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("32% Off", style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }
}
