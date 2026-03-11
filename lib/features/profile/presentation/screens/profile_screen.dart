import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wanis_app/features/profile/presentation/screens/edit_kid_profile_screen.dart';
import 'package:wanis_app/features/parent/presentation/widgets/parent_gate_dialog.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 48), // Spacer for centering
                    Text(
                      'حسابي 👤',
                      style: GoogleFonts.readexPro(
                        color: const Color(0xFF2D3748),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x0C000000),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          )
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Color(0xFFA0AEC0)),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              
              // Avatar
              GestureDetector(
                onTap: () {
                   Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditKidProfileScreen(),
                    ),
                  );
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFFFECCC), // Placeholder bg color if needed
                        image: const DecorationImage(
                          image: AssetImage('assets/images/boy_avatar.png'), // Replace with actual asset if different or use SVG
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: -10,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Color(0xFF5D9CEC),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x335D9CEC),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            )
                          ],
                        ),
                        child: const Icon(Icons.edit, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // Name text
              Text(
                'البطل زين 🦸‍♂️',
                style: GoogleFonts.readexPro(
                  color: const Color(0xFF2D3748),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 42),
              
              // Settings Group
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    // Sounds and Music Switch
                    _buildSettingTile(
                      icon: '🎵',
                      iconBgColor: const Color(0xFFFEEBC8),
                      title: 'الأصوات والموسيقى',
                      trailing: Switch(
                        value: true,
                        onChanged: (val) {},
                        activeThumbColor: Colors.white,
                        activeTrackColor: const Color(0xFF48C774),
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: const Color(0xFFE2E8F0),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Notifications Switch
                    _buildSettingTile(
                      icon: '🔔',
                      iconBgColor: const Color(0xFFEBF8FF),
                      title: 'التنبيهات',
                      trailing: Switch(
                        value: false,
                        onChanged: (val) {},
                        activeThumbColor: Colors.white,
                        activeTrackColor: const Color(0xFF48C774),
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: const Color(0xFFE2E8F0),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 48),
              
              // Parent Settings Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => const ParentGateDialog(),
                    );
                  },
                  child: Container(
                    height: 80,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0C000000),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.arrow_back_ios, color: Color(0xFFCBD5E0), size: 16),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'إعدادات الوالدين',
                                  style: GoogleFonts.readexPro(
                                    color: const Color(0xFF2D3748),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'التقارير - الإعدادات - الحساب',
                                  style: GoogleFonts.readexPro(
                                    color: const Color(0xFFA0AEC0),
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 15),
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF5EB),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                child: Text(
                                  '👨‍👩‍👦',
                                  style: TextStyle(fontSize: 24),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required String icon,
    required Color iconBgColor,
    required String title,
    required Widget trailing,
  }) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          trailing,
          Row(
            children: [
              Text(
                title,
                style: GoogleFonts.readexPro(
                  color: const Color(0xFF2D3748),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 15),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(icon, style: const TextStyle(fontSize: 24)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
