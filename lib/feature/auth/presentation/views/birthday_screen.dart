import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/core/common/widgets/ig_button.dart';
import 'package:flutter_instagram_clone/core/common/widgets/section_title.dart';
import 'package:flutter_instagram_clone/feature/auth/presentation/views/username_setup_screen.dart';
import 'package:flutter_instagram_clone/feature/auth/presentation/widgets/already_have_an_account_section.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class BirthdayScreen extends StatefulWidget {
  const BirthdayScreen({super.key});

  @override
  State<BirthdayScreen> createState() => _BirthdayScreenState();
}

class _BirthdayScreenState extends State<BirthdayScreen> {
  final TextEditingController _birthdayController = TextEditingController();

  DateTime _selectionDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _updateBirthdayText(_selectionDate);
  }

  void _updateBirthdayText(DateTime date) {
    // Format "Nov 14, 2011"
    final months = [
      'jan',
      'feb',
      'mar',
      'apr',
      'may',
      'jun',
      'jul',
      'aug',
      'sep',
      'oct',
      'nov',
      'dec',
    ];
    final formatedDate = "${months[date.month - 1]} ${date.day}, ${date.year}";
    _birthdayController.text = formatedDate;
  }

  @override
  void dispose() {
    _birthdayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 10.h),
              SectionTitle(
                title: 'What\'s your birthday?',
                subTitle:
                    'Use your own birthday, even if this account is for business, a pet, or something else. No one well see this unless you chose to share it.',
              ),
              SizedBox(height: 20.h),
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  height: 48.h,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: Color(0xff201d1d),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade800),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _birthdayController.text,
                          style: GoogleFonts.outfit(color: Colors.white),
                        ),
                      ),
                      Icon(
                        Icons.calendar_today,
                        color: Colors.grey,
                        size: 18.sp,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: IGButton(
                  text: 'Next',
                  onPressed: () {
                    // Navigate to username setup screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context)
                        =>  UsernameSetupScreen()

                      ),
                    );
                  },
                ),
              ),
              Spacer(),
              AlreadyHaveAnAccountSection(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectionDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.blue,
              onPrimary: Colors.white,
              surface: Color(0xff121212),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      setState(() {
        _selectionDate = pickedDate;
        _updateBirthdayText(pickedDate);
      });
    }
  }
}
