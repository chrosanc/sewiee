import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sewiee/presentation/account/account_viewmodel.dart';
import 'package:sewiee/presentation/account/address/address_screen.dart';
import 'package:sewiee/presentation/account/edit_profile_screen.dart';
import 'package:sewiee/presentation/merchant/manage/manage_merchant_screen.dart';
import 'package:sewiee/presentation/merchant/manage/manage_merchant_viewmodel.dart';
import 'package:sewiee/presentation/widget/merchant_status/merchant_verified_widget.dart';

// ─── Design tokens ────────────────────────────────────────────────────────
const _kDark       = Color(0xFF1C1E26);
const _kAmber      = Color(0xFFFFB113);
const _kAmberLight = Color(0xFFFFF4E0);
const _kAmberText  = Color(0xFFB87214);
const _kRed        = Color(0xFFE24B4A);
const _kRedLight   = Color(0xFFFEF2F2);
const _kBorder     = Color(0xFFE5E5E5);
const _kDivider    = Color(0xFFF0F0F0);
const _kSurface    = Color(0xFFF7F7F5);
const _kTextMain   = Color(0xFF1A1A1A);
const _kTextMuted  = Color(0xFF9CA3AF);
const double _kOverlap = 100.0;

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await Provider.of<AccountViewmodel>(context, listen: false)
          .getCurrentUser(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AccountViewmodel>(context);

    return Scaffold(
      backgroundColor: _kSurface,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => viewModel.getCurrentUser(context),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header banner ────────────────────────────────────────
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 200,
                      width: double.infinity,
                      color: _kDark,
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: _ProfileHeader(viewModel: viewModel, bottomPadding: _kOverlap,),
                        ),
                        SizedBox(
                          height: 200,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: MerchantVerifiedWidget(
                              storeName: viewModel.userModel?.storeName,
                              activeOrder:
                              viewModel.userModel?.totalTransactions.toString(),
                              totalProduct:
                              viewModel.userModel?.totalProducts.toString(),
                              storeRating:
                              viewModel.userModel?.storeRating.toString(),
                              onTap: () {
                                context
                                    .read<ManageMerchantViewmodel>()
                                    .setUser(viewModel.userModel!);
                                context
                                    .read<ManageMerchantViewmodel>()
                                    .getProductByCurrentUser(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ManageMerchantScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),

                  ],
                ),

                // ── Merchant card (overlaps header) ──────────────────────

                SizedBox(height: 20,),

                // ── Menu group: account settings ─────────────────────────
                _MenuSection(
                  label: 'Akun',
                  items: [
                    _MenuItem(
                      title: 'Ubah Profil',
                      description: 'Atur nama, username, dan bio kamu',
                      icon: Icons.person_rounded,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                        );
                      },
                    ),
                    _MenuItem(
                      title: 'Daftar Alamat',
                      description: 'Atur alamat pengiriman',
                      icon: Icons.pin_drop_rounded,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AddressScreen()),
                        );
                      },
                    ),
                    _MenuItem(
                      title: 'Notifikasi',
                      description: 'Atur notifikasi aplikasi',
                      icon: Icons.notifications_rounded,
                      onTap: () => viewModel.showLoadingDialog(),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // ── Menu group: logout (destructive, isolated) ────────────
                _MenuSection(
                  items: [
                    _MenuItem(
                      title: 'Keluar',
                      description: 'Keluar akun',
                      icon: Icons.logout_rounded,
                      isDestructive: true,
                      onTap: () => viewModel.logout(context),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
//  PROFILE HEADER
// ═════════════════════════════════════════════════════════════════════════════
class _ProfileHeader extends StatelessWidget {
  final AccountViewmodel viewModel;
  final double bottomPadding;
  const _ProfileHeader({required this.viewModel, this.bottomPadding= 0});

  @override
  Widget build(BuildContext context) {
    final user = viewModel.userModel;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Avatar
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: user?.profileImage != null ? Colors.transparent : _kAmber,
            shape: BoxShape.circle,
          ),
          clipBehavior: Clip.antiAlias,
          child: user?.profileImage != null
              ? Image.network(user!.profileImage!, fit: BoxFit.cover)
              : Center(
            child: Text(
              // Initials fallback: first letter of full name
              (user?.fullName.isNotEmpty == true)
                  ? user!.fullName[0].toUpperCase()
                  : '?',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),

        const SizedBox(width: 14),

        // Name + username
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user?.username ?? '@username',
                style: const TextStyle(
                  fontSize: 11,
                  color: _kTextMuted,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                user?.fullName ?? 'Nama Lengkap',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
//  MENU SECTION  (optional label + a card of menu items)
// ═════════════════════════════════════════════════════════════════════════════
class _MenuSection extends StatelessWidget {
  final String? label;
  final List<_MenuItem> items;

  const _MenuSection({
    this.label,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null) ...[
            Text(
              label!.toUpperCase(),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: _kTextMuted,
                letterSpacing: 0.6,
              ),
            ),
            const SizedBox(height: 8),
          ],
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _kBorder, width: 0.5),
            ),
            child: Column(
              children: items
                  .asMap()
                  .entries
                  .map((entry) => Column(
                children: [
                  entry.value,
                  if (entry.key < items.length - 1)
                    const Divider(
                      height: 1,
                      thickness: 0.5,
                      color: _kDivider,
                      indent: 14,
                      endIndent: 14,
                    ),
                ],
              ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
//  MENU ITEM
// ═════════════════════════════════════════════════════════════════════════════
class _MenuItem extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback? onTap;
  final bool isDestructive;

  const _MenuItem({
    required this.title,
    required this.description,
    required this.icon,
    this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color iconBg    = isDestructive ? _kRedLight   : _kAmberLight;
    final Color iconColor = isDestructive ? _kRed        : _kAmber;
    final Color titleColor = isDestructive ? _kRed       : _kTextMain;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        child: Row(
          children: [
            // Icon container
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icon, size: 18, color: iconColor),
            ),

            const SizedBox(width: 12),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 11,
                      color: _kTextMuted,
                    ),
                  ),
                ],
              ),
            ),

            // Chevron
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: isDestructive ? _kRed.withValues(alpha: .5) : _kTextMuted,
            ),
          ],
        ),
      ),
    );
  }
}