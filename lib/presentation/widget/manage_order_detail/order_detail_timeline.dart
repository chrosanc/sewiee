import 'package:flutter/material.dart';
import 'package:sewiee/app/screen_theme/order_detail_theme.dart';
import 'package:sewiee/domain/enum/delivery_method_enum.dart';
import 'package:sewiee/domain/enum/order_status.dart';
import 'package:sewiee/domain/enum/return_method_enum.dart';
import 'package:sewiee/presentation/widget/manage_order_detail/order_detail_primitives.dart';

enum TimelineState { done, active, pending }

class TimelineStep {
  final String label;
  final OrderStatus status;
  final TimelineState state;
  final String? time;

  const TimelineStep(
    this.label,
    this.status, {
    this.state = TimelineState.pending,
    this.time,
  });
}

class OrderTimelineCard extends StatelessWidget {
  final OrderStatus status;
  final DeliveryMethod deliveryMethod;
  final ReturnMethod returnMethod;

  const OrderTimelineCard({
    super.key,
    required this.status,
    required this.deliveryMethod,
    required this.returnMethod,
  });

  @override
  Widget build(BuildContext context) {
    final steps = _buildSteps();

    return SectionCard(
      iconBg: const Color(0xFFE1F5EE),
      iconColor: const Color(0xFF0F6E56),
      iconData: Icons.timeline_outlined,
      title: 'Riwayat Status',
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
        child: Column(
          children: List.generate(steps.length, (index) {
            final step = steps[index];
            final isLast = index == steps.length - 1;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 20,
                  child: Column(
                    children: [
                      TimelineDot(state: step.state),
                      if (!isLast)
                        Container(
                          width: 1.5,
                          height: 28,
                          color: step.state == TimelineState.done
                              ? const Color(0xFFC0DD97)
                              : OrderDetailTheme.divider,
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: isLast ? 10 : 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step.label,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: step.state == TimelineState.active
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: _textColor(step.state),
                          ),
                        ),
                        if (step.time != null) ...[
                          const SizedBox(height: 1),
                          Text(
                            step.time!,
                            style: const TextStyle(
                              fontSize: 10,
                              color: OrderDetailTheme.textMuted,
                            ),
                          ),
                        ],
                        const SizedBox(height: 14),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  List<TimelineStep> _buildSteps() {
    if (status == OrderStatus.cancelled) {
      return const [
        TimelineStep(
          'Dibatalkan',
          OrderStatus.cancelled,
          state: TimelineState.active,
          time: 'Status saat ini',
        ),
      ];
    }

    final deliveryStep = deliveryMethod == DeliveryMethod.expedition
        ? const TimelineStep('Dalam Pengiriman', OrderStatus.onDelivery)
        : TimelineStep(
            deliveryMethod == DeliveryMethod.renterPickup ? 'Siap Pickup' : 'Siap Diantar',
            OrderStatus.waitingPickup,
          );

    final returnTransitStep = returnMethod == ReturnMethod.expedition
        ? const TimelineStep('Pengembalian Dikirim', OrderStatus.returnOnDelivery)
        : null;

    final steps = [
      const TimelineStep('Menunggu Pembayaran', OrderStatus.waitingPayment),
      const TimelineStep('Sudah Dibayar', OrderStatus.paid),
      const TimelineStep('Menunggu Konfirmasi', OrderStatus.waitingConfirmation),
      const TimelineStep('Pesanan Diproses', OrderStatus.processing),
      deliveryStep,
      const TimelineStep('Diterima Penyewa', OrderStatus.delivered),
      const TimelineStep('Sedang Disewa', OrderStatus.onRent),
      const TimelineStep('Menunggu Pengembalian', OrderStatus.returnPending),
      if (returnTransitStep != null) returnTransitStep,
      const TimelineStep('Dikembalikan', OrderStatus.returned),
      const TimelineStep('Dalam Pengecekan', OrderStatus.onInspection),
      const TimelineStep('Selesai', OrderStatus.completed),
    ];

    final statusOrder = steps.map((s) => s.status).toList();
    var currentIndex = statusOrder.indexOf(status);
    if (currentIndex == -1 && status == OrderStatus.lateReturn) {
      currentIndex = statusOrder.indexOf(OrderStatus.onRent);
    }
    if (currentIndex == -1) currentIndex = 0;

    return List.generate(steps.length, (index) {
      final state = index < currentIndex
          ? TimelineState.done
          : index == currentIndex
              ? TimelineState.active
              : TimelineState.pending;

      return TimelineStep(
        steps[index].label,
        steps[index].status,
        state: state,
        time: state == TimelineState.pending ? null : 'Sudah dilalui',
      );
    });
  }

  Color _textColor(TimelineState state) {
    switch (state) {
      case TimelineState.done:
        return OrderDetailTheme.textPrimary;
      case TimelineState.active:
        return const Color(0xFF185FA5);
      case TimelineState.pending:
        return OrderDetailTheme.textDisabled;
    }
  }
}

class TimelineDot extends StatelessWidget {
  final TimelineState state;

  const TimelineDot({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case TimelineState.done:
        return Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF639922),
            border: Border.all(color: const Color(0xFFEAF3DE), width: 2),
          ),
        );
      case TimelineState.active:
        return Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF378ADD),
            border: Border.all(color: const Color(0xFFE6F1FB), width: 2),
          ),
        );
      case TimelineState.pending:
        return Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: const Color(0xFFD3D1C7), width: 1.5),
          ),
        );
    }
  }
}
