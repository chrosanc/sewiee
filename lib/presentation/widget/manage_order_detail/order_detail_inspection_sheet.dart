import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sewiee/app/screen_theme/order_detail_theme.dart';
import 'package:sewiee/data/model/order_model.dart';
import 'package:sewiee/presentation/widget/manage_order_detail/order_detail_primitives.dart';

Future<int?> showInspectionBrokenFineSheet(
    BuildContext context, {
      required TextEditingController controller,
      required OrderModel order,
    }) {
  final formKey = GlobalKey<FormState>();

  return showModalBottomSheet<int>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            border: Border(
              top: BorderSide(color: OrderDetailTheme.border, width: 0.5),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 32,
                height: 3,
                margin: const EdgeInsets.only(top: 10, bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFD3D1C7),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: OrderDetailTheme.iconBg,
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: const Icon(
                        Icons.assignment_turned_in_outlined,
                        size: 16,
                        color: OrderDetailTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Konfirmasi inspeksi',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: OrderDetailTheme.textPrimary,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Masukkan nominal denda jika ada kerusakan',
                            style: TextStyle(
                              fontSize: 11,
                              color: OrderDetailTheme.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F7F4),
                          shape: BoxShape.circle,
                          border: Border.all(color: OrderDetailTheme.border, width: 0.5),
                        ),
                        child: const Icon(Icons.close, size: 13, color: OrderDetailTheme.textMuted),
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 0.5, color: Color(0xFFF0EEE8)),

              // Body
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Order chip
                      _DendaOrderChip(order: order),
                      const SizedBox(height: 12),

                      // Label
                      const Text(
                        'Nominal denda',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF5F5E5A),
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Input
                      TextFormField(
                        controller: controller,
                        autofocus: true,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        style: const TextStyle(
                          fontSize: 13,
                          color: OrderDetailTheme.textPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Kosongkan jika tidak ada kerusakan',
                          hintStyle: const TextStyle(
                            fontSize: 13,
                            color: OrderDetailTheme.textDisabled,
                          ),
                          prefixIcon: const Icon(
                            Icons.monetization_on_outlined,
                            size: 18,
                            color: OrderDetailTheme.textDisabled,
                          ),
                          prefixText: 'Rp ',
                          prefixStyle: const TextStyle(
                            fontSize: 13,
                            color: OrderDetailTheme.textPrimary,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
                          filled: true,
                          fillColor: Colors.white,
                          border: _inputBorder(),
                          enabledBorder: _inputBorder(),
                          focusedBorder: _inputBorder(color: OrderDetailTheme.textPrimary, width: 1),
                          errorBorder: _inputBorder(color: const Color(0xFFE24B4A)),
                        ),
                        validator: (value) {
                          if (value != null && value.trim().isNotEmpty &&
                              int.tryParse(value.trim()) == null) {
                            return 'Masukkan angka yang valid';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 5),

                      // Helper text
                      const Row(
                        children: [
                          Icon(Icons.info_outline, size: 12, color: OrderDetailTheme.textDisabled),
                          SizedBox(width: 4),
                          Text(
                            'Kosongkan jika barang dalam kondisi baik',
                            style: TextStyle(fontSize: 10, color: OrderDetailTheme.textDisabled),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Buttons
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: DialogButton.primary(
                              label: 'Konfirmasi / Tagih denda',
                              onTap: () {
                                if (formKey.currentState!.validate()) {
                                  final amount = int.tryParse(controller.text.trim()) ?? 0;
                                  Navigator.pop(context, amount);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

OutlineInputBorder _inputBorder({
  Color color = const Color(0xFFD3D1C7),
  double width = 0.5,
}) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: color, width: width),
  );
}

class _DendaOrderChip extends StatelessWidget {
  final OrderModel order;

  const _DendaOrderChip({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F7F4),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFEDEAE3), width: 0.5),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: order.productSnapshot.image.isNotEmpty
                ? Image.network(
              order.productSnapshot.image,
              width: 28,
              height: 28,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SmallImageFallback(),
            )
                : const SmallImageFallback(),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.productSnapshot.name,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: OrderDetailTheme.textPrimary,
                  ),
                ),
                Text(
                  order.orderNumber,
                  style: const TextStyle(fontSize: 10, color: OrderDetailTheme.textMuted),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Denda',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Color(0xFF92400E),
              ),
            ),
          ),
        ],
      ),
    );
  }
}