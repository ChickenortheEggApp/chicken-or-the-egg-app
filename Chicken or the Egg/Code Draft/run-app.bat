@echo off
echo.
echo ========================================
echo   🐔 Chicken or the Egg - Google Sign-In Test
echo ========================================
echo.
echo Starting Flutter app with Google Sign-In...
echo.
echo Instructions:
echo 1. The app will open in your browser
echo 2. Click "Sign In with Google" button
echo 3. Complete the Google OAuth flow
echo 4. You should be signed in successfully!
echo.
echo Press any key to start the app...
pause >nul

cd /d "E:\Chicken App Development\Chicken or the Egg\Code Draft"
E:\Flutter\bin\flutter run -d chrome

echo.
echo App has been launched!
echo If there are any issues, check the troubleshooting guide.
pause
