import 'package:flutter/material.dart';
import 'package:nabatdex/core/constant/app_theme.dart';
import 'package:nabatdex/features/scanner/presentation/widgets/dialog_body.dart';
import 'package:nabatdex/features/scanner/presentation/widgets/dialog_content.dart';

class ConfirmImageDialog extends StatelessWidget {
  const ConfirmImageDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return DialogBody(
      dialogContent: DialogContent(
        dialogContentChildren: [
          Text(
            'Konfirmasi Foto',
            style: TextTheme.of(
              context,
            ).headlineMedium?.copyWith(color: AppTheme.accentColor),
          ),
          const SizedBox(height: 16),
          Image.asset(
            'assets/image/image_not_found.png',
            width: double.infinity,
            height: 300,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 16),
          Text(
            "Pastikan foto daun jelas dengan pencahayaan cukup",
            style: TextTheme.of(
              context,
            ).bodyMedium?.copyWith(color: AppTheme.whiteColor),
          ),
          const SizedBox(height: 8),
          Text(
            "Tekan tombol lanjutkan jika sudah benar.",
            style: TextTheme.of(
              context,
            ).bodyMedium?.copyWith(color: AppTheme.whiteColor),
          ),

          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Batal',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppTheme.secondaryColor,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => {},
                child: Text(
                  'Lanjutkan',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppTheme.secondaryColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
