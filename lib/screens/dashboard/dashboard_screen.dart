import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'category_workers_screen.dart';
import '../../controllers/auth_controller.dart';
import '../../data/repositories/service_repository.dart';
import '../../data/repositories/booking_repository.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/app_avatar.dart';
import '../plans/choose_plan_screen.dart';
import '../profile/profile_screen.dart';
import '../bookings/booking_screen.dart';
import '../../core/services/storage_service.dart';
import '../../core/services/location_service.dart';
import '../../core/utils/helpers.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final authController = Get.isRegistered<AuthController>() ? Get.find<AuthController>() : null;
      var isWorker = authController?.user.value?.isWorker ?? false;

      // Fallback check in local storage if user value in controller was momentarily unpopulated
      if (!isWorker && Get.isRegistered<StorageService>()) {
        try {
          final storage = Get.find<StorageService>();
          final dynamic raw = storage.read('current_user');
          if (raw is Map && raw['role'] == 'worker') {
            isWorker = true;
          }
        } catch (_) {}
      }

      final List<Widget> pages = isWorker
          ? const [
              BookingScreen(),
              ChoosePlanScreen(showBackButton: false),
              ProfileScreen(),
            ]
          : const [
              HomeScreen(),
              CategoryWorkersScreen(categoryName: 'Workers'),
              BookingScreen(),
              ProfileScreen(),
            ];

      final List<BottomNavigationBarItem> navItems = isWorker
          ? const [
              BottomNavigationBarItem(
                icon: Icon(Icons.assignment_outlined),
                activeIcon: Icon(Icons.assignment),
                label: 'Requests',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.workspace_premium_outlined),
                activeIcon: Icon(Icons.workspace_premium),
                label: 'Plans',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ]
          : const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.engineering_outlined),
                activeIcon: Icon(Icons.engineering),
                label: 'Workers',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month_outlined),
                activeIcon: Icon(Icons.calendar_month),
                label: 'Bookings',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ];

      final safeIndex = _selectedIndex < pages.length ? _selectedIndex : 0;

      return Scaffold(
        body: pages[safeIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: safeIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.deepOrange,
          unselectedItemColor: Colors.grey,
          items: navItems,
        ),
      );
    });
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ServiceRepository _serviceRepository = ServiceRepository();
  List<Map<String, dynamic>> _topWorkers = [];
  bool _isLoadingWorkers = true;
  String _currentCity = 'Locating...';
  String _currentSubArea = 'Fetching address';

  @override
  void initState() {
    super.initState();
    _loadTopWorkers();
  }

  Future<void> _loadTopWorkers() async {
    setState(() => _isLoadingWorkers = true);

    // 1. Fetch workers immediately so list loads fast
    final workersFuture = _serviceRepository.fetchWorkers();

    // 2. Fetch location in parallel
    LocationService.getCurrentPosition().then((pos) async {
      if (pos != null && mounted) {
        final address = await LocationService.getAddressFromCoordinates(
          latitude: pos.latitude,
          longitude: pos.longitude,
        );
        if (mounted) {
          setState(() {
            _currentCity = address['city'] ?? 'Nearby';
            _currentSubArea = address['subArea']?.isNotEmpty == true
                ? address['subArea']!
                : (address['state'] ?? 'Current Location');
          });
        }
      }
    }).catchError((_) {});

    final workers = await workersFuture;
    if (mounted) {
      setState(() {
        _isLoadingWorkers = false;
        _topWorkers = workers;
      });
    }
  }

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
              child: const Icon(Icons.location_on, color: Colors.deepOrange, size: 20),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          _currentCity,
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Color(0xFF001F3F)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.keyboard_arrow_down, size: 16, color: Color(0xFF001F3F)),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _currentSubArea,
                    style: TextStyle(
                      color: const Color(0xFF001F3F).withOpacity(0.7),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
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
                        const Text('Sector 62, Noida', style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w500)),
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
                  autoPlay: false,
                  enlargeCenterPage: true,
                  viewportFraction: 0.92,
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                ),
              items: [1].map((i) {
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
            
            _isLoadingWorkers
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: CircularProgressIndicator(color: Colors.deepOrange),
                    ),
                  )
                : _topWorkers.isEmpty
                    ? Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.deepOrange.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.people_outline, color: Colors.deepOrange),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'No Workers Yet',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                  Text(
                                    'New service professionals will appear here as they sign up.',
                                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : CarouselSlider(
                        options: CarouselOptions(
                          height: 270.0,
                          autoPlay: _topWorkers.length > 1,
                          enlargeCenterPage: true,
                          viewportFraction: 0.9,
                          autoPlayInterval: const Duration(seconds: 4),
                          autoPlayAnimationDuration: const Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                        ),
                        items: _topWorkers.map((w) {
                          return _buildWorkerCard(
                            name: w['name'] ?? 'Worker',
                            role: w['role'] ?? w['skills'] ?? 'Professional',
                            rating: w['rating'] ?? '5.0',
                            reviews: w['reviews'] ?? '1',
                            location: w['distanceKm'] != null ? '${w['city'] ?? 'Nearby'} (${w['distanceKm']})' : (w['location'] ?? w['city'] ?? 'Delhi NCR'),
                            price: w['price'] ?? '₹299',
                            skills: w['skills'] ?? '',
                            image: w['image'] ?? w['avatar'] ?? 'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?q=80&w=200&auto=format&fit=crop',
                            phone: w['phone'],
                            workerId: w['id'],
                          );
                        }).toList(),
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
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(16),
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
    String? phone,
    String? workerId,
  }) {
    void handleContact(String method) {
      if (phone != null && phone.isNotEmpty) {
        // 1. Log Inquiry so worker receives an inquiry card with customer name & number
        final authCtrl = Get.isRegistered<AuthController>() ? Get.find<AuthController>() : null;
        final currentUser = authCtrl?.user.value;
        final customerName = (currentUser?.name.isNotEmpty == true &&
                currentUser!.name != 'User' &&
                currentUser.name != 'Service Worker')
            ? currentUser.name
            : 'HomeFix Customer';
        final customerPhone = (currentUser?.phone?.isNotEmpty == true)
            ? currentUser!.phone!
            : (authCtrl?.fullPhoneNumber.isNotEmpty == true
                ? authCtrl!.fullPhoneNumber
                : 'Customer');

        final bookingRepo = BookingRepository();
        bookingRepo.logInquiry(
          workerId: workerId,
          workerPhone: phone,
          customerId: currentUser?.id,
          customerName: customerName,
          customerPhone: customerPhone,
          location: location,
          contactMethod: method,
        );

        // 2. Open Call or WhatsApp
        if (method == 'Call') {
          Helpers.makePhoneCall(phone);
        } else {
          Helpers.openWhatsApp(phone);
        }
      }
    }

    return Container(
      width: double.infinity, margin: const EdgeInsets.only(bottom: 8, top: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Image
              Stack(
                children: [
                  AppAvatar(
                    avatarUrl: image,
                    size: 60,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(width: 4),
                        const Icon(Icons.verified, color: Colors.orange, size: 16),
                      ],
                    ),
                    Text(role, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange, size: 14),
                        const SizedBox(width: 4),
                        Text(rating, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        Text(' ($reviews)', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.orange, size: 14),
                        const SizedBox(width: 4),
                        Text(location, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Price and View Profile
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // View Profile chhota sa uper
                  InkWell(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('View Profile', style: TextStyle(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const Text('per visit', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Skills & Buttons
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    skills,
                    style: const TextStyle(color: Colors.black54, fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => handleContact('Call'),
                  icon: const Icon(Icons.phone, color: Colors.orange, size: 16),
                  label: const Text('Call', style: TextStyle(color: Colors.orange)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.orange),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => handleContact('WhatsApp'),
                  icon: const Icon(Icons.chat, color: Colors.white, size: 16),
                  label: const Text('WhatsApp'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


