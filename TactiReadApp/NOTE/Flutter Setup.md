# Flutter 개발환경 설정 가이드

## 현재 시스템 진단 결과 ✅

### 설치된 소프트웨어
- ✅ **Flutter 3.16.5** (업데이트 필요)
- ✅ **Git 2.36.1** 
- ✅ **VS Code** (2개 버전 설치됨)
- ✅ **Android Studio 2022.3**
- ✅ **Chrome**
- ⚠️ **Visual Studio** (구성요소 누락)

### 해결해야 할 문제
1. **Flutter 업데이트** (최신 버전으로)
2. **PATH 경로 충돌** 수정
3. **Visual Studio 구성요소** 추가 설치

## 1. 현재 시스템 상태 확인

### Flutter 설치 확인
```powershell
flutter --version
```

### Git 설치 확인
```powershell
git --version
```

### Visual Studio Code 설치 확인
```powershell
code --version
```

## 즉시 해결해야 할 문제들

### 1단계: Flutter 업데이트
```powershell
# Flutter 최신 버전으로 업데이트
flutter upgrade

# 업데이트 후 버전 확인
flutter --version
```

### 2단계: PATH 경로 충돌 해결 🔥 **긴급**
**현재 상태 진단**:
- ✅ Flutter: `D:\ALOHA\SETUP\flutter\bin\flutter.bat`
- ❌ Dart: `C:\tools\dart-sdk\bin\dart.exe` (충돌 발생)

**문제**: Dart SDK 경로가 충돌하고 있음
```
C:\tools\dart-sdk\bin\dart.exe ❌ (제거 필요)
D:\ALOHA\SETUP\flutter\bin ✅ (우선순위 높여야 함)
```

**해결 방법**:
1. **환경 변수 편집**:
   - `Win + R` → `sysdm.cpl` → **환경 변수**
   - **시스템 변수**에서 `Path` 선택 → **편집**

2. **경로 우선순위 조정**:
   - `D:\ALOHA\SETUP\flutter\bin`을 **맨 위로** 이동
   - `C:\tools\dart-sdk\bin` 항목이 있다면 **삭제**

3. **PowerShell 재시작** 후 확인:
```powershell
Get-Command flutter  # D:\ALOHA\SETUP\flutter\bin\flutter.bat
Get-Command dart     # D:\ALOHA\SETUP\flutter\bin\cache\dart-sdk\bin\dart.exe
```

**⚠️ 중요**: 이 단계를 완료하기 전까지는 `flutter doctor`에서 경고가 계속 발생합니다.

### 3단계: Visual Studio 구성요소 설치 🔧 **[실행 중]**
**현재 상태**: Visual Studio Build Tools 2022 17.6.4 설치됨
**문제**: Flutter에서 요구하는 정확한 C++ 구성요소 누락

```
X Visual Studio is missing necessary components. Please re-run the Visual Studio installer for   
  the "Desktop development with C++" workload, and include these components:
    MSVC v142 - VS 2019 C++ x64/x86 build tools
     - If there are multiple build tool versions available, install the latest
    C++ CMake tools for Windows
    Windows 10 SDK
```

```
Start-Process "C:\Program Files (x86)\Microsoft Visual Studio\Installer\vs_installer.exe" -Verb RunAs
```

**✅ Visual Studio Installer 실행됨!** 이제 정확한 단계를 따라하세요:

#### 📋 필수 C++ 구성요소 설치 가이드:

**1단계: 제품 선택**
   - Visual Studio Installer 창에서 **"Visual Studio Build Tools 2022"** 찾기
   - 오른쪽의 **"수정"** 버튼 클릭

**2단계: 워크로드 선택**
   - **"워크로드"** 탭에서:
   - ✅ **"C++를 사용한 데스크톱 개발"** (Desktop development with C++) 체크

**3단계: 개별 구성 요소 필수 확인** ⚠️ **중요**
   - **"개별 구성 요소"** 탭 클릭
   - 검색창에서 각 항목을 찾아 **반드시 체크**:
   
   **🔸 MSVC 컴파일러 (필수)**:
   - ✅ **MSVC v142 - VS 2019 C++ x64/x86 빌드 도구** (최신 버전)
   - ✅ **MSVC v143 - VS 2022 C++ x64/x86 빌드 도구** (추천)
   
   **🔸 CMake 도구 (필수)**:
   - ✅ **Windows용 C++ CMake 도구**
   
   **🔸 Windows SDK (필수)**:
   - ✅ **Windows 10 SDK (10.0.19041.0)** 또는 최신
   - ✅ **Windows 11 SDK (10.0.22000.0)** (권장)

   **🔸 추가 도구 (권장)**:
   - ✅ **Windows Universal CRT SDK**
   - ✅ **Git for Windows** (이미 설치됨)

**4단계: 설치 확인 및 실행**
   - 선택된 구성요소 **총 용량 확인** (약 2-4GB)
   - 오른쪽 하단의 **"수정"** 버튼 클릭
   - **다운로드 및 설치 진행** (10-20분 소요)
   - 완료 후 **재부팅** 권장

**5단계: 설치 완료 확인**
   ```powershell
   # PowerShell 새로 열고 확인
   flutter doctor -v
   ```
   
   **기대 결과**:
   ```
   [✓] Visual Studio - develop Windows apps (Visual Studio Build Tools 2022 17.6.4)
   ```

#### 🚨 주의사항:
- **MSVC v142 (VS 2019)** 는 Flutter에서 명시적으로 요구하는 필수 구성요소입니다
- **최신 버전** 을 선택하되, v142는 반드시 포함해야 합니다
- **Windows 10 SDK** 는 최소 10.0.19041.0 이상이어야 합니다

#### 🔍 문제 해결 가이드:

**만약 Visual Studio Installer에서 구성요소를 찾을 수 없다면:**

1. **MSVC v142 찾기**:
   - 개별 구성 요소 검색창에 `v142` 입력
   - `MSVC v142 - VS 2019 C++ x64/x86 build tools (Latest)` 선택

2. **CMake 도구 찾기**:
   - 검색창에 `cmake` 입력  
   - `C++ CMake tools for Windows` 선택

3. **Windows SDK 찾기**:
   - 검색창에 `Windows 10 SDK` 입력
   - 가장 높은 버전 번호 선택 (예: 10.0.22621.0)

**Visual Studio Installer가 응답하지 않는 경우:**
```powershell
# 작업 관리자에서 vs_installer.exe 프로세스 종료 후 재실행
taskkill /f /im "vs_installer.exe"
Start-Process "C:\Program Files (x86)\Microsoft Visual Studio\Installer\vs_installer.exe" -Verb RunAs
```

**설치 중 오류가 발생하는 경우:**
- 디스크 용량 확인 (최소 5GB 여유 공간 필요)
- 관리자 권한으로 실행되었는지 확인
- 바이러스 백신 프로그램 일시 비활성화
- 재부팅 후 재시도

### 4단계: 최종 검증
```powershell
# 모든 설정 완료 후 재검사
flutter doctor -v

# 모든 항목이 ✅로 나와야 함:
# [✓] Flutter
# [✓] Windows Version  
# [✓] Android toolchain
# [✓] Chrome
# [✓] Visual Studio (이제 ✓로 변경되어야 함)
# [✓] Android Studio
# [✓] VS Code
```

## 📋 현재 상황 요약

### ✅ 완료된 작업
- **Flutter 업데이트**: 3.16.5 → 3.32.7 (최신)
- **기본 도구들**: Git, VS Code, Android Studio, Chrome 모두 설치됨

### 🔄 진행해야 할 작업
1. **PATH 환경 변수 수정** (사용자 직접 수행 필요)
2. **Visual Studio 구성요소 설치** (사용자 직접 수행 필요)

### 🎯 다음 단계
위 2개 작업 완료 후 → `flutter doctor` 실행 → 모든 항목 ✅ 확인

---

## TactiRead 프로젝트를 위한 Flutter 앱 생성 준비

환경 설정이 완료되면 다음 명령으로 프로젝트를 시작할 수 있습니다:

```powershell
# TactiRead 디렉토리에서
cd "e:\로그엔코딩\DEV\TactiRead"

# 새 Flutter 프로젝트 생성
flutter create tacti_read_app

# 프로젝트 디렉토리로 이동
cd tacti_read_app

# 의존성 확인
flutter pub get

# 사용 가능한 플랫폼 확인
flutter devices

# 웹에서 테스트 실행
flutter run -d chrome
```

## 2. 필수 요구사항

### 시스템 요구사항
- **OS**: Windows 10 이상 (64-bit)
- **디스크 공간**: 2.8 GB (IDE 및 도구 제외)
- **도구**: Windows PowerShell 5.0 이상

### 필수 소프트웨어
1. **Git for Windows**
2. **Visual Studio Code** (권장 IDE)
3. **Android Studio** (Android 개발용)
4. **Chrome** (웹 개발용)

## 3. Flutter SDK 설치

### 방법 1: 공식 웹사이트에서 다운로드
1. [Flutter 공식 사이트](https://flutter.dev/docs/get-started/install/windows) 방문
2. "Get the Flutter SDK" 섹션에서 Flutter SDK 다운로드
3. 다운로드한 zip 파일을 `C:\src\flutter`에 압축 해제

### 방법 2: Git을 사용한 설치 (권장)
```powershell
# 설치 디렉토리 생성
mkdir C:\src
cd C:\src

# Flutter SDK 클론
git clone https://github.com/flutter/flutter.git -b stable
```

## 4. 환경 변수 설정

### Flutter를 PATH에 추가
1. **시스템 속성** 열기:
   - `Win + R` → `sysdm.cpl` 입력 → Enter
   - 또는 제어판 → 시스템 → 고급 시스템 설정

2. **환경 변수** 클릭

3. **시스템 변수**에서 `Path` 선택 후 **편집**

4. **새로 만들기** 클릭 후 다음 경로 추가:
   ```
   C:\src\flutter\bin
   ```

5. **확인** 클릭하여 저장

### PowerShell에서 즉시 적용
```powershell
# 현재 세션에서 PATH 업데이트
$env:PATH += ";C:\src\flutter\bin"

# Flutter 설치 확인
flutter --version
```

## 5. Flutter Doctor 실행

### 시스템 상태 진단
```powershell
flutter doctor
```

### 예상 출력 및 해결방법
```
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 3.x.x, on Microsoft Windows)
[✗] Android toolchain - develop for Android devices
[✗] Chrome - develop for the web
[✗] Visual Studio - develop for Windows
[✗] Android Studio (not installed)
[✗] VS Code (not installed)
```

## 6. Android 개발 환경 설정

### Android Studio 설치
1. [Android Studio 다운로드](https://developer.android.com/studio)
2. 설치 과정에서 다음 구성요소 포함:
   - Android SDK
   - Android SDK Platform-Tools
   - Android SDK Build-Tools
   - Android Emulator

### Android SDK 라이선스 동의
```powershell
flutter doctor --android-licenses
```

### Android 에뮬레이터 생성
```powershell
# Android Studio에서 AVD Manager 열기
# 또는 명령줄에서:
flutter emulators
flutter emulators --launch <emulator_name>
```

## 7. Visual Studio Code 설정

### VS Code 설치
1. [VS Code 다운로드](https://code.visualstudio.com/)
2. 설치 후 필수 확장 프로그램 설치

### 필수 확장 프로그램
```powershell
# VS Code에서 확장 프로그램 설치
code --install-extension Dart-Code.dart-code
code --install-extension Dart-Code.flutter
```

### 또는 VS Code에서 직접 설치:
- **Dart**
- **Flutter**
- **Flutter Widget Snippets** (선택사항)
- **Awesome Flutter Snippets** (선택사항)

## 8. 웹 개발 환경 설정

### Chrome 설치 확인
```powershell
# Chrome이 설치되어 있는지 확인
where chrome
```

### 웹 지원 활성화
```powershell
flutter config --enable-web
```

## 9. Windows 데스크톱 앱 개발 설정

### Visual Studio 2022 설치
1. [Visual Studio 2022 Community](https://visualstudio.microsoft.com/downloads/) 다운로드
2. 설치 시 다음 워크로드 선택:
   - **C++를 사용한 데스크톱 개발**
   - **Windows 10/11 SDK**

### Windows 지원 활성화
```powershell
flutter config --enable-windows-desktop
```

## 10. 최종 검증

### Flutter Doctor 재실행
```powershell
flutter doctor -v
```

### 모든 항목이 ✓로 표시되어야 함:
- [✓] Flutter
- [✓] Android toolchain
- [✓] Chrome
- [✓] Visual Studio
- [✓] Android Studio
- [✓] VS Code

## 11. 첫 Flutter 프로젝트 생성

### 새 프로젝트 생성
```powershell
# 프로젝트 디렉토리로 이동
cd "e:\로그엔코딩\DEV\TactiRead"

# 새 Flutter 프로젝트 생성
flutter create tacti_read_app
cd tacti_read_app
```

### 프로젝트 실행
```powershell
# 사용 가능한 디바이스 확인
flutter devices

# 웹에서 실행
flutter run -d chrome

# Android 에뮬레이터에서 실행
flutter run -d android

# Windows 데스크톱에서 실행
flutter run -d windows
```

## 12. 개발 도구 설정

### Flutter Inspector 사용
```powershell
# VS Code에서 Flutter 프로젝트 열기
code .

# F5 키로 디버그 모드 실행
# Ctrl+Shift+P → "Flutter: Launch DevTools"
```

### Hot Reload 사용
- **Hot Reload**: `r` (빠른 UI 업데이트)
- **Hot Restart**: `R` (전체 앱 재시작)
- **Quit**: `q` (앱 종료)

## 13. 문제 해결

### 일반적인 문제들

#### PowerShell 실행 정책 오류
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

#### PATH 환경 변수 인식 안됨
```powershell
# PowerShell 재시작 후
refreshenv
```

#### Android 라이선스 문제
```powershell
flutter doctor --android-licenses
# 모든 라이선스에 'y' 입력
```

#### VS Code에서 Flutter 인식 안됨
1. VS Code 재시작
2. `Ctrl+Shift+P` → "Flutter: Reload"
3. Dart/Flutter 확장 프로그램 재설치

## 14. 유용한 명령어 모음

### Flutter 관련
```powershell
# Flutter 버전 확인
flutter --version

# Flutter 채널 확인
flutter channel

# Flutter 업그레이드
flutter upgrade

# 캐시 정리
flutter clean

# 패키지 업데이트
flutter pub get

# 빌드
flutter build apk          # Android APK
flutter build web          # 웹
flutter build windows      # Windows
```

### 디버깅
```powershell
# 디바이스 목록
flutter devices

# 로그 확인
flutter logs

# 성능 분석
flutter analyze
```

## 15. 참고 자료

- [Flutter 공식 문서](https://flutter.dev/docs)
- [Dart 언어 가이드](https://dart.dev/guides)
- [Flutter Widget 카탈로그](https://flutter.dev/docs/development/ui/widgets)
- [Flutter 코드랩](https://flutter.dev/docs/codelabs)

---

**설치 완료 후 `flutter doctor`가 모든 항목에서 ✓를 표시하면 개발 준비가 완료됩니다!**
