import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/property_controller.dart';
import '../../widgets/loading_widget.dart';
import '../../core/utils/helpers.dart';

class PropertyScreen extends StatelessWidget {
  const PropertyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final propertyController = Get.find<PropertyController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Properties')),
      body: Obx(() {
        if (propertyController.isLoading.value) {
          return const LoadingWidget(message: 'Loading properties...');
        }

        if (propertyController.properties.isEmpty) {
          return const Center(child: Text('No properties available'));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: propertyController.properties.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final property = propertyController.properties[index];
            return Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              child: ListTile(
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.apartment, color: Color(0xFF2563EB)),
                ),
                title: Text(property.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(property.address),
                trailing: Text(
                  Helpers.formatCurrency(property.price),
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF10B981)),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
