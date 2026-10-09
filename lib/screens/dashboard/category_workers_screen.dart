import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/custom_app_bar.dart';

class CategoryWorkersScreen extends StatefulWidget {
  final String categoryName;
  const CategoryWorkersScreen({Key? key, required this.categoryName}) : super(key: key);

  @override
  _CategoryWorkersScreenState createState() => _CategoryWorkersScreenState();
}

class _CategoryWorkersScreenState extends State<CategoryWorkersScreen> {
  final List<String> categories = ['All', 'Electrician', 'Plumber', 'Carpenter', 'Painter'];
  String selectedCategory = 'All';

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
                      setState(() {
                        selectedCategory = categories[index];
                      });
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
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildWorkerCard(
                  name: 'Rohit Kumar',
                  role: 'Electrician',
                  rating: '4.8',
                  reviews: '128 reviews',
                  location: 'Moradabad, UP',
                  price: '₹300',
                  skills: 'Electrical Repair, Wiring, Installation',
                  image: 'https://i.pravatar.cc/150?img=11',
                ),
                _buildWorkerCard(
                  name: 'Amit Sharma',
                  role: 'Plumber',
                  rating: '4.6',
                  reviews: '96 reviews',
                  location: 'Rampur, UP',
                  price: '₹250',
                  skills: 'Pipe Fitting, Leakage, Bathroom Repair',
                  image: 'https://i.pravatar.cc/150?img=12',
                ),
                _buildWorkerCard(
                  name: 'Sandeep Yadav',
                  role: 'Carpenter',
                  rating: '4.7',
                  reviews: '84 reviews',
                  location: 'Moradabad, UP',
                  price: '₹350',
                  skills: 'Furniture, Doors, Windows, Modular Work',
                  image: 'https://i.pravatar.cc/150?img=13',
                ),
                _buildWorkerCard(
                  name: 'Imran Khan',
                  role: 'Painter',
                  rating: '4.5',
                  reviews: '62 reviews',
                  location: 'Amroha, UP',
                  price: '₹280',
                  skills: 'Wall Painting, Texture, Polish',
                  image: 'https://i.pravatar.cc/150?img=14',
                ),
              ],
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
  }) {
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      image,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
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
                  onPressed: () {},
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
                  onPressed: () {},
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
