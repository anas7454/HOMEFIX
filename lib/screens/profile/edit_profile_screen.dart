import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/auth_controller.dart';
import '../../core/utils/helpers.dart';
import '../../widgets/app_avatar.dart';
import '../../widgets/custom_app_bar.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  String? _localImagePath;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _prefillData();
    _fetchLatestProfile();
  }

  void _prefillData() {
    if (Get.isRegistered<AuthController>()) {
      final authCtrl = Get.find<AuthController>();
      final user = authCtrl.user.value;

      final phone = (user?.phone?.isNotEmpty ?? false)
          ? user!.phone!
          : (authCtrl.fullPhoneNumber.isNotEmpty
              ? authCtrl.fullPhoneNumber
              : authCtrl.userPhoneClean);

      if (phone.isNotEmpty) {
        _phoneController.text = phone;
      }

      if (user != null) {
        if (user.name.isNotEmpty && user.name != 'User' && user.name != 'Service Worker') {
          _nameController.text = user.name;
        } else if (user.name.isNotEmpty) {
          _nameController.text = user.name;
        }
        _emailController.text = user.email ?? '';
      }
    }
  }

  Future<void> _fetchLatestProfile() async {
    if (!Get.isRegistered<AuthController>()) return;
    final authCtrl = Get.find<AuthController>();
    final current = authCtrl.user.value;
    if (current == null) return;

    try {
      final fresh = await authCtrl.authRepository.getProfile(current.id);
      if (fresh != null && mounted) {
        authCtrl.user.value = fresh;
        await authCtrl.saveUserLocally(fresh);
        if (_nameController.text.isEmpty && fresh.name.isNotEmpty) {
          _nameController.text = fresh.name;
        }
        if (_emailController.text.isEmpty && (fresh.email?.isNotEmpty ?? false)) {
          _emailController.text = fresh.email!;
        }
        if (_phoneController.text.isEmpty && (fresh.phone?.isNotEmpty ?? false)) {
          _phoneController.text = fresh.phone!;
        }
        setState(() {});
      }
    } catch (e) {
      debugPrint('Error fetching fresh profile: $e');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? file = await _picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );
      if (file != null) {
        setState(() {
          _localImagePath = file.path;
        });
      }
    } catch (e) {
      Helpers.showSnackbar(
        message: 'Could not select photo: $e',
        isError: true,
      );
    }
  }

  void _showImagePickerModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Change Profile Photo',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF001F3F),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.deepOrange),
                title: const Text('Take a Photo (Camera)'),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.deepOrange),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveChanges() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      Helpers.showSnackbar(
        message: 'Please enter your Full Name',
        isError: true,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (Get.isRegistered<AuthController>()) {
        final authCtrl = Get.find<AuthController>();
        final currentUser = authCtrl.user.value;
        if (currentUser != null) {
          String? avatarUrl = currentUser.avatar;

          // If a new local image was picked, process/upload it
          if (_localImagePath != null && _localImagePath!.isNotEmpty) {
            final uploaded = await authCtrl.authRepository.processAvatar(
              userId: currentUser.id,
              filePath: _localImagePath!,
            );
            if (uploaded != null) {
              avatarUrl = uploaded;
            }
          }

          final email = _emailController.text.trim();
          final phone = _phoneController.text.trim();

          final updatedUser = await authCtrl.authRepository.updateProfile(
            id: currentUser.id,
            fullName: name,
            avatarUrl: avatarUrl,
            phone: phone.isNotEmpty ? phone : currentUser.phone,
            email: email.isNotEmpty ? email : null,
          );

          if (updatedUser != null) {
            authCtrl.user.value = updatedUser;
          } else {
            authCtrl.user.value = currentUser.copyWith(
              name: name,
              avatar: avatarUrl,
              phone: phone.isNotEmpty ? phone : currentUser.phone,
              email: email.isNotEmpty ? email : null,
            );
          }
          await authCtrl.saveUserLocally(authCtrl.user.value!);

          Helpers.showSnackbar(
            title: 'Profile Updated',
            message: 'Your profile has been saved successfully!',
          );

          Get.back();
          return;
        }
      }

      Get.back();
    } catch (e) {
      Helpers.showSnackbar(
        message: 'Failed to update profile: $e',
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authCtrl = Get.isRegistered<AuthController>() ? Get.find<AuthController>() : null;
    final userAvatar = authCtrl?.user.value?.avatar;

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      appBar: const CustomAppBar(
        title: 'Edit Profile',
        showBackButton: true,
        showDefaultActions: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 105,
                      height: 105,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: Colors.deepOrange.withOpacity(0.4), width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: _localImagePath != null
                            ? Image.file(
                                File(_localImagePath!),
                                width: 105,
                                height: 105,
                                fit: BoxFit.cover,
                              )
                            : AppAvatar(
                                avatarUrl: userAvatar,
                                size: 105,
                              ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _showImagePickerModal,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.deepOrange,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 35),
              _buildTextField('Full Name', _nameController, Icons.person_outline),
              const SizedBox(height: 18),
              _buildTextField('Email Address', _emailController, Icons.email_outlined, keyboardType: TextInputType.emailAddress),
              _buildTextField(
                _phoneController.text.trim().isNotEmpty
                    ? 'Phone Number (Verified)'
                    : 'Phone Number',
                _phoneController,
                Icons.phone_outlined,
                enabled: _phoneController.text.trim().isEmpty,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 36),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                        )
                      : const Text(
                          'Save Changes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool enabled = true,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF001F3F),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          style: TextStyle(
            color: enabled ? const Color(0xFF001F3F) : Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: enabled ? Colors.deepOrange : Colors.grey),
            filled: true,
            fillColor: enabled ? Colors.white : Colors.grey.shade100,
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.deepOrange, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
