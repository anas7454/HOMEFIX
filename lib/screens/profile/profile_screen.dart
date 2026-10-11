import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/app_avatar.dart';
import '../../widgets/custom_app_bar.dart';
import '../../controllers/auth_controller.dart';
import 'edit_profile_screen.dart';
import 'privacy_policy_screen.dart';
import 'terms_conditions_screen.dart';
import 'about_us_screen.dart';
import 'contact_us_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      appBar: const CustomAppBar(
        title: 'Profile',
        showBackButton: false,
        showDefaultActions: false,
        actions: [
          Icon(Icons.settings, color: Color(0xFF001F3F), size: 24),
          SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // ==========================================
              // DYNAMIC USER / WORKER INFO CARD (REACTIVE)
              // ==========================================
              Obx(() {
                final authCtrl = Get.isRegistered<AuthController>() ? Get.find<AuthController>() : null;
                final currentUser = authCtrl?.user.value;
                final displayName = (currentUser?.name.isNotEmpty ?? false)
                    ? currentUser!.name
                    : (currentUser?.isWorker ?? false ? 'HomeFix Worker' : 'HomeFix Customer');
                final roleOrPhone = currentUser?.phone ?? '+91 98765 43210';
                final roleBadge = (currentUser?.role ?? 'customer').toUpperCase();
                final avatarUrl = currentUser?.avatar;

                return InkWell(
                  onTap: () => Get.to(() => const EditProfileScreen()),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Dynamic Profile Avatar (Network, Base64, or File)
                        AppAvatar(
                          avatarUrl: avatarUrl,
                          size: 70,
                          border: Border.all(color: Colors.deepOrange.withOpacity(0.3), width: 2),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Online Status
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: const BoxDecoration(
                                        color: Colors.green,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Text(
                                      'Online',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                displayName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF001F3F),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '$roleBadge • $roleOrPhone',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, size: 12, color: Colors.deepOrange),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Delhi NCR, India',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                      ],
                    ),
                  ),
                );
              }),

              // ==========================================
              // WORKER STATS (ONLY FOR WORKERS)
              // ==========================================
              Obx(() {
                final authCtrl = Get.isRegistered<AuthController>() ? Get.find<AuthController>() : null;
                final isWorker = authCtrl?.user.value?.isWorker ?? false;

                if (!isWorker) {
                  return const SizedBox.shrink();
                }

                return Column(
                  children: [
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatItem(Icons.star, '5.0', 'Rating'),
                          Container(width: 1, height: 35, color: Colors.grey.shade200),
                          _buildStatItem(Icons.work, 'Active', 'Status'),
                          Container(width: 1, height: 35, color: Colors.grey.shade200),
                          _buildStatItem(Icons.verified, 'Verified', 'Badge'),
                        ],
                      ),
                    ),
                  ],
                );
              }),

              const SizedBox(height: 20),

              // ==========================================
              // MENU ITEMS
              // ==========================================
              _buildCardMenuItem(
                icon: Icons.edit,
                title: 'Edit Profile',
                subtitle: 'Update your name, profile photo & email',
                isHighlight: true,
                onTap: () {
                  Get.to(() => const EditProfileScreen());
                },
              ),

              _buildCardMenuItem(
                icon: Icons.location_on,
                title: 'Manage Addresses',
                subtitle: 'Add or update your addresses',
                onTap: () {},
              ),

              _buildCardMenuItem(
                icon: Icons.help_outline,
                title: 'Help & Support',
                subtitle: 'Get help with your queries',
                onTap: () {
                  Get.to(() => const ContactUsScreen());
                },
              ),

              _buildCardMenuItem(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                subtitle: 'Read our privacy policy',
                onTap: () {
                  Get.to(() => const PrivacyPolicyScreen());
                },
              ),

              _buildCardMenuItem(
                icon: Icons.description_outlined,
                title: 'Terms & Conditions',
                subtitle: 'Read our terms of use',
                onTap: () {
                  Get.to(() => const TermsConditionsScreen());
                },
              ),

              _buildCardMenuItem(
                icon: Icons.info_outline,
                title: 'About HomeFix',
                subtitle: 'Know more about us',
                onTap: () {
                  Get.to(() => const AboutUsScreen());
                },
              ),

              const SizedBox(height: 24),

              // Logout Button
              OutlinedButton(
                onPressed: () {
                  final authController = Get.find<AuthController>();
                  authController.logout();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, size: 20),
                    SizedBox(width: 8),
                    Text('Logout', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.deepOrange, size: 22),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF001F3F),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildCardMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    bool isHighlight = false,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isHighlight ? Colors.orange.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isHighlight ? Colors.orange.shade200 : Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        dense: true,
        visualDensity: const VisualDensity(vertical: -2),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isHighlight ? Colors.deepOrange : Colors.orange.shade50,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isHighlight ? Colors.white : Colors.deepOrange,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isHighlight ? Colors.deepOrange : const Color(0xFF001F3F),
            fontSize: 14,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(
                  color: isHighlight ? Colors.deepOrange.withOpacity(0.7) : Colors.grey.shade500,
                  fontSize: 11,
                ),
              )
            : null,
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: isHighlight ? Colors.deepOrange : Colors.grey,
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
