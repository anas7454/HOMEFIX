import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/app_avatar.dart';
import '../../controllers/auth_controller.dart';
import '../../data/repositories/service_repository.dart';
import '../../data/repositories/booking_repository.dart';
import '../../core/utils/helpers.dart';
import '../../core/services/location_service.dart';

class CategoryWorkersScreen extends StatefulWidget {
  final String categoryName;
  const CategoryWorkersScreen({Key? key, required this.categoryName}) : super(key: key);

  @override
  _CategoryWorkersScreenState createState() => _CategoryWorkersScreenState();
}

class _CategoryWorkersScreenState extends State<CategoryWorkersScreen> {
  final ServiceRepository _serviceRepository = ServiceRepository();
  final List<String> categories = ['All', 'Electrician', 'Plumber', 'Carpenter', 'Painting', 'AC Repair', 'Cleaning'];
  late String selectedCategory;
  bool _isLoading = true;
  List<Map<String, dynamic>> _realWorkers = [];

  @override
  void initState() {
    super.initState();
    final initialCat = widget.categoryName;
    if (categories.any((c) => c.toLowerCase() == initialCat.toLowerCase())) {
      selectedCategory = categories.firstWhere((c) => c.toLowerCase() == initialCat.toLowerCase());
    } else {
      selectedCategory = initialCat.toLowerCase() == 'workers' ? 'All' : initialCat;
    }
    _loadWorkers();
  }

  Future<void> _loadWorkers() async {
    setState(() => _isLoading = true);

    final catToFilter = selectedCategory == 'All' ? null : selectedCategory;
    final workers = await _serviceRepository.fetchWorkers(
      category: catToFilter,
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
        _realWorkers = workers;
      });
    }

    // Enrich with distances in background
    LocationService.getCurrentPosition().then((pos) async {
      if (pos != null && mounted) {
        final enriched = await _serviceRepository.fetchWorkers(
          category: catToFilter,
          userLatitude: pos.latitude,
          userLongitude: pos.longitude,
        );
        if (mounted && enriched.isNotEmpty) {
          setState(() {
            _realWorkers = enriched;
          });
        }
      }
    }).catchError((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7), // Light background color from image
      appBar: CustomAppBar(
        title: widget.categoryName,

        showDefaultActions: false, // Override defaults
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: Color(0xFF001F3F)),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search worker, service...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.black12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.black12),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          
          // Categories
          SizedBox(
            height: 45,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final isSelected = selectedCategory == categories[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0, top: 4, bottom: 4),
                  child: ChoiceChip(
                    label: Text(
                      categories[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selectedCategory != categories[index]) {
                        setState(() {
                          selectedCategory = categories[index];
                        });
                        _loadWorkers();
                      }
                    },
                    selectedColor: Colors.orange,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: isSelected ? Colors.orange : Colors.grey.shade200),
                    ),
                    showCheckmark: false,
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Worker List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.deepOrange))
                : _realWorkers.isEmpty
                    ? RefreshIndicator(
                        color: Colors.deepOrange,
                        onRefresh: _loadWorkers,
                        child: ListView(
                          children: [
                            SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.deepOrange.shade50,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.engineering_outlined,
                                      size: 40,
                                      color: Colors.deepOrange,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'No Workers Registered Yet',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF001F3F),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'When workers sign up in Supabase, they will appear here.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton.icon(
                                    onPressed: _loadWorkers,
                                    icon: const Icon(Icons.refresh, size: 16),
                                    label: const Text('Refresh'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.deepOrange,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        color: Colors.deepOrange,
                        onRefresh: _loadWorkers,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _realWorkers.length,
                          itemBuilder: (context, index) {
                            final worker = _realWorkers[index];
                            return _buildWorkerCard(
                              name: worker['name'] ?? 'Worker',
                              role: worker['skills'] ?? widget.categoryName,
                              rating: worker['rating'] ?? '5.0',
                              reviews: '${worker['reviews'] ?? '1'} review',
                              location: worker['distanceKm'] != null ? '${worker['city'] ?? 'Nearby'} (${worker['distanceKm']})' : (worker['city'] ?? worker['location'] ?? 'Delhi NCR'),
                              price: worker['price'] ?? '₹299',
                              skills: worker['skills'] ?? '',
                              image: worker['image'] ?? worker['avatar'] ?? 'https://i.pravatar.cc/150?img=11',
                              phone: worker['phone'],
                              workerId: worker['id'],
                            );
                          },
                        ),
                      ),
          ),
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
      margin: const EdgeInsets.only(bottom: 16),
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