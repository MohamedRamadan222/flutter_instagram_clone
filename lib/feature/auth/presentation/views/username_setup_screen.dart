import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/core/common/widgets/section_title.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/common/widgets/ig_button.dart';

class UsernameSetupScreen extends StatefulWidget {
  const UsernameSetupScreen({super.key});

  @override
  State<UsernameSetupScreen> createState() => _UsernameSetupScreenState();
}

class _UsernameSetupScreenState extends State<UsernameSetupScreen> {
  final controller = TextEditingController();
  bool _isUsernameValid = true;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      final valid = controller.text.length > 2;
      if (valid != _isUsernameValid) {
        setState(() => _isUsernameValid = valid);
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              title: 'Create username',
              subTitle:
                  'Add a username or use our suggestion. You can change this at any time.',
            ),
            SizedBox(height: 20.h),
            _inputField(controller),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: IGButton(
                text: 'Next',
                onPressed: _isUsernameValid
                    ? () {
                        // Navigate to terms step
                        context.push('/signup/terms');
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField(TextEditingController controller) {
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Color(0xff201d1d),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _isUsernameValid ? Colors.grey.shade800 : Colors.red,
        ),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          style: GoogleFonts.outfit(color: Colors.white),
          decoration: InputDecoration(
            border: InputBorder.none,
            isDense: true,
            hintText: 'Username',
            hintStyle: GoogleFonts.outfit(color: Colors.grey, fontSize: 14.sp),
            suffixIconConstraints: BoxConstraints(minHeight: 20, maxWidth: 20),
            suffixIcon: _isUsernameValid
                ? Icon(Icons.check_circle, color: Colors.green, size: 20)
                : Icon(Icons.cancel, color: Colors.red, size: 20),
          ),
        ),
      ),
    );
  }
}
