import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../onboarding/presentation/screens/onboarding_splash_screen.dart';
import '../../../../services/auth_service.dart';

class ParentDashboardScreen extends StatefulWidget {
  const ParentDashboardScreen({super.key});

  @override
  State<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen> {
  // Toggle this false to show empty state
  final bool _hasData = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0C000000),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          )
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFFA0AEC0), size: 18),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 48,
                      height: 48,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0C000000),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          )
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.logout, color: Colors.redAccent, size: 22),
                        onPressed: () => _showLogoutDialog(context),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'لوحة المتابعة 📊',
                          style: GoogleFonts.readexPro(
                            color: const Color(0xFF2D3748),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'تقرير نشاط زين هذا الأسبوع',
                          style: GoogleFonts.readexPro(
                            color: const Color(0xFFA0AEC0),
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              // Stats Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        icon: _hasData ? '😊' : '😐',
                        iconBgColor: _hasData ? const Color(0xFFEBF8FF) : const Color(0xFFF7F9FC),
                        title: 'المزاج الغالب',
                        value: _hasData ? 'سعيد' : '--',
                        valueStyle: _hasData
                            ? GoogleFonts.readexPro(
                                color: const Color(0xFF2D3748),
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              )
                            : const TextStyle( // Fallback if no data
                                fontFamily: 'Arial',
                                color: Color(0xFFCBD5E0),
                                fontSize: 24,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                              ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatCard(
                        icon: '⏳',
                        iconBgColor: _hasData ? const Color(0xFFFFF5EB) : const Color(0xFFF7F9FC),
                        title: 'وقت التعلم',
                        value: _hasData ? '45 د' : '0 د',
                        valueStyle: GoogleFonts.readexPro(
                          color: _hasData ? const Color(0xFF2D3748) : const Color(0xFFCBD5E0),
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              // Chart Area (Simplified Representation)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  height: 250,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0C000000),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'تطور الأداء',
                        style: GoogleFonts.readexPro(
                          color: const Color(0xFF2D3748),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (_hasData) 
                        Expanded(child: _buildMockChart())
                      else
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('💤', style: TextStyle(fontSize: 48)),
                              const SizedBox(height: 16),
                              Text(
                                'لا توجد بيانات حتى الآن',
                                style: GoogleFonts.readexPro(
                                  color: const Color(0xFF2D3748),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'شجع زين على اللعب لتظهر الإحصائيات هنا',
                                style: GoogleFonts.readexPro(
                                  color: const Color(0xFFA0AEC0),
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Recent Activity / Empty State Tip
              if (_hasData) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    'النشاط الأخير',
                    style: GoogleFonts.readexPro(
                      color: const Color(0xFF2D3748),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      _buildActivityItem(
                        icon: '🎭',
                        iconBgColor: const Color(0xFFEBF8FF),
                        title: 'مطابقة المشاعر',
                        subtitle: 'أكمل بنجاح (3/3)',
                        subtitleColor: const Color(0xFF48C774),
                        time: 'منذ 2 ساعة',
                      ),
                      const SizedBox(height: 12),
                      _buildActivityItem(
                        icon: '📖',
                        iconBgColor: const Color(0xFFFFF5EB),
                        title: 'قصة: عمر واللعبة',
                        subtitle: 'تعرف على "الحزن"',
                        subtitleColor: const Color(0xFFF4A261),
                        time: 'أمس',
                      ),
                    ],
                  ),
                ),
              ] else ...[
                 Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 24.0),
                   child: Container(
                     padding: const EdgeInsets.symmetric(vertical: 18),
                     decoration: BoxDecoration(
                       color: const Color(0xFFEBF8FF),
                       borderRadius: BorderRadius.circular(86),
                     ),
                     child: Center(
                        child: Text(
                          '💡 نصيحة: ابدأ بقصة عمر',
                          style: GoogleFonts.readexPro(
                            color: const Color(0xFF5D9CEC),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                     ),
                   ),
                 ),
              ],
              
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext contextDialog) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'تسجيل الخروج',
            textAlign: TextAlign.right,
            style: GoogleFonts.readexPro(
              color: const Color(0xFF2D3748),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'هل أنت متأكد من رغبتك في تسجيل الخروج؟',
            textAlign: TextAlign.right,
            style: GoogleFonts.readexPro(
              color: const Color(0xFFA0AEC0),
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(contextDialog).pop(),
              child: Text(
                'إلغاء',
                style: GoogleFonts.readexPro(color: const Color(0xFFA0AEC0)),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                final navigator = Navigator.of(context);
                Navigator.of(contextDialog).pop(); // Close dialog
                final authService = AuthService();
                await authService.signOut();
                navigator.pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) => const OnboardingSplashScreen(),
                  ),
                  (route) => false,
                );
              },
              child: Text(
                'تأكيد',
                style: GoogleFonts.readexPro(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard({
    required String icon,
    required Color iconBgColor,
    required String title,
    required String value,
    required TextStyle valueStyle,
  }) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(16),
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
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(icon, style: const TextStyle(fontSize: 20)),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: GoogleFonts.readexPro(
                  color: const Color(0xFFA0AEC0),
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: valueStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem({
    required String icon,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required Color subtitleColor,
    required String time,
  }) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          Text(
            time,
            style: const TextStyle(
              fontFamily: 'Arial',
              color: Color(0xFFA0AEC0),
              fontSize: 12,
            ),
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.readexPro(
                      color: const Color(0xFF2D3748),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.readexPro(
                      color: subtitleColor,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
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

  Widget _buildMockChart() {
    // Placeholder for a bar chart
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildChartBar('جمعة', 40, false),
        _buildChartBar('خميس', 60, false),
        _buildChartBar('أربعاء', 30, false),
        _buildChartBar('ثلاثاء', 100, true), // Active day
        _buildChartBar('إثنين', 50, false),
        _buildChartBar('أحد', 70, false),
        _buildChartBar('سبت', 20, false),
      ],
    );
  }

  Widget _buildChartBar(String day, double height, bool isActive) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 20,
          height: height,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF5D9CEC) : const Color(0xFFE2E8F0),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          day,
          style: GoogleFonts.readexPro(
            color: isActive ? const Color(0xFF5D9CEC) : const Color(0xFFA0AEC0),
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
