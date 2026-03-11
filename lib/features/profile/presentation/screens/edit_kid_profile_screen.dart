import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditKidProfileScreen extends StatefulWidget {
  const EditKidProfileScreen({super.key});

  @override
  State<EditKidProfileScreen> createState() => _EditKidProfileScreenState();
}

class _EditKidProfileScreenState extends State<EditKidProfileScreen> {
  final TextEditingController _nameController = TextEditingController(text: 'البطل زين 🦸‍♂️');
  int _selectedAvatarIndex = 0;

  final List<String> _avatars = [
    'assets/images/boy_avatar.png',
    'assets/images/girl_avatar_1.png',
    'assets/images/boy_avatar_2.png',
    'assets/images/girl_avatar_2.png',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

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
                    const SizedBox(width: 48), // Spacer
                    Text(
                      'تعديل الحساب',
                      style: GoogleFonts.readexPro(
                        color: const Color(0xFF2D3748),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
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
                        onPressed: () => Navigator.of(context).pop(), // This is fine since EditKidProfileScreen is pushed ON TOP of ProfileScreen
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              // Change Avatar Section
              Text(
                'اختر شخصيتك المفضلة',
                style: GoogleFonts.readexPro(
                  color: const Color(0xFF2D3748),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              
              // Avatar Grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 20,
                  runSpacing: 20,
                  children: List.generate(_avatars.length, (index) {
                    final isSelected = _selectedAvatarIndex == index;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedAvatarIndex = index;
                        });
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected ? const Color(0xFFEBF8FF) : const Color(0xFFFFF5EB),
                              border: isSelected
                                  ? Border.all(color: const Color(0xFF5D9CEC), width: 3)
                                  : Border.all(color: Colors.transparent, width: 3),
                            ),
                            child: Center(
                              // Replace with actual image when available, using Icon for now if assets missing
                              child: index == 0 ? Image.asset('assets/images/boy_avatar.png', errorBuilder: (_,__,___) => const Icon(Icons.person, size: 60, color: Colors.blue)) : 
                                     index == 1 ? const Icon(Icons.face_3, size: 60, color: Colors.pink) :
                                     index == 2 ? const Icon(Icons.face_4, size: 60, color: Colors.green) :
                                     const Icon(Icons.face_5, size: 60, color: Colors.orange)
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 48),

              // Edit Name Input
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'اسمي',
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
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextField(
                    controller: _nameController,
                    style: GoogleFonts.readexPro(
                      color: const Color(0xFF2D3748),
                      fontSize: 18,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFF5D9CEC)),
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 60),

              // Save Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF48C774),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'حفظ التغييرات',
                      style: GoogleFonts.readexPro(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
