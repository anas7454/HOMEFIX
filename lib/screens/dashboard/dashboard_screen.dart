import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'category_workers_screen.dart';
import '../../controllers/auth_controller.dart';
import '../../app/routes/app_routes.dart';
import '../../widgets/custom_app_bar.dart';
import '../plans/choose_plan_screen.dart';
import '../profile/profile_screen.dart';
import '../bookings/booking_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const BookingScreen(),
    const ChoosePlanScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), activeIcon: Icon(Icons.calendar_month), label: 'Bookings'),
          BottomNavigationBarItem(icon: Icon(Icons.workspace_premium_outlined), activeIcon: Icon(Icons.workspace_premium), label: 'Plan'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7), // Premium off-white background
      appBar: CustomAppBar(
        titleWidget: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.location_on, color: Color(0xFF001F3F), size: 20),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: const [
                    Text('Delhi', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Color(0xFF001F3F))),
                    SizedBox(width: 4),
                    Icon(Icons.keyboard_arrow_down, size: 16, color: Color(0xFF001F3F)),
                  ],
                ),
                const SizedBox(height: 2),
                Text('Sector 62, Noida', style: TextStyle(color: const Color(0xFF001F3F).withOpacity(0.7), fontSize: 12, fontWeight: FontWeight.w500)),
              ],
            ),
          ],
        ),
        showBackButton: false,
        showDefaultActions: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF001F3F)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Badge(
              label: Text('3'),
              child: Icon(Icons.notifications_none, color: Color(0xFF001F3F)),
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /* // Premium Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.location_on, color: Colors.deepOrange, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Text('Delhi', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Color(0xFF001F3F))),
                            SizedBox(width: 4),
                            Icon(Icons.keyboard_arrow_down, size: 16, color: Color(0xFF001F3F)),
                          ],
                        ),
                        const SizedBox(height: 2),
                        const Text('Sector 62, Noida', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: const Icon(Icons.search, size: 22, color: Color(0xFF001F3F)),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: const Badge(
                        label: Text('3'),
                        child: Icon(Icons.notifications_none, size: 22, color: Color(0xFF001F3F)),
                      ),
                    ),
                  ],
                ),
              ), */
              
              const SizedBox(height: 20),
              
              // Carousel
              CarouselSlider(
                options: CarouselOptions(
                  height: 140.0,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.92,
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                ),
              items: [1, 2].map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                          image: AssetImage('assets/images/banner$i.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // Trust Badges
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTrustBadge(Icons.verified, 'Verified\nProfessionals', Colors.orange),
                  _buildTrustBadge(Icons.security, 'Safe & Secure\nPayments', Colors.green),
                  _buildTrustBadge(Icons.support_agent, 'On-Time\nService', Colors.orange),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Popular Services Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Popular Services', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF001F3F))),
                  Text('View All', style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              childAspectRatio: 0.95,
              mainAxisSpacing: 16,
              crossAxisSpacing: 12,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildServiceIcon('Electrician', 'electrician.png', Colors.yellow.shade50),
                _buildServiceIcon('Plumber', 'plumber.png', Colors.blue.shade50),
                _buildServiceIcon('Carpenter', 'carpenter.png', Colors.orange.shade50),
                _buildServiceIcon('AC Repair', 'ac_repair.png', Colors.lightBlue.shade50),

                _buildServiceIcon('Painter', 'painter.png', Colors.red.shade50),
                _buildServiceIcon('Mason', 'mason.png', Colors.deepOrange.shade50),
                _buildServiceIcon('Cleaning', 'cleaning.png', Colors.green.shade50),
              ],
            ),

            const SizedBox(height: 28),

            // Top Rated Professionals Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Top Rated Professionals', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF001F3F))),
                  Text('View All', style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            SizedBox(
              height: 220,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildWorkerCard(name: 'Rohit Sharma', role: 'Electrician', rating: '4.8', reviews: '120', location: '2 km away', price: '?299', skills: 'Wiring, Switchboard', image: 'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?q=80&w=200&auto=format&fit=crop'),
                  _buildWorkerCard(name: 'Amit Verma', role: 'Plumber', rating: '4.7', reviews: '85', location: '3 km away', price: '?199', skills: 'Pipe Fitting, Leakage', image: 'https://images.unsplash.com/photo-1540569014015-19a7be504e3a?q=80&w=200&auto=format&fit=crop'),
                  _buildWorkerCard(name: 'Sandeep K', role: 'Painter', rating: '4.9', reviews: '200', location: '1 km away', price: '?499', skills: 'Wall Painting, Texture', image: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=200&auto=format&fit=crop'),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    ),
    );
  }

  Widget _buildTrustBadge(IconData icon, String text, Color iconColor) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildServiceIcon(String label, String iconName, Color bgColor) {
    return InkWell(
      onTap: () {
        Get.to(() => CategoryWorkersScreen(categoryName: label.replaceAll('\n', ' ')));
      },
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: bgColor.withOpacity(0.5),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Image.asset(
                'assets/images/worker/$iconName',
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, size: 24),
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF001F3F))),
        ],
      ),
    );
  }

  Widget _buildWorkerCard({
    required String name,
    required String role,
    required String rating,
    required String reviews,
    required String location,
    required String price,
    required String skills,
    required String image,
  }) {
    return Container(
      width: 190,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  image,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 48,
                    height: 48,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.person, color: Colors.grey),
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 12),
                    const SizedBox(width: 2),
                    Text(rating, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.verified, color: Colors.orange, size: 14),
            ],
          ),
          Text(role, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
          const SizedBox(height: 8),
          Row(
            children: [
              Text('$reviews reviews', style: const TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.location_on, size: 12, color: Colors.grey),
              const SizedBox(width: 2),
              Expanded(
                child: Text(
                  location,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            skills,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.deepOrange),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
              child: const Text('Book Now', style: TextStyle(color: Colors.deepOrange)),
            ),
          ),
        ],
      ),
    );
  }
}

