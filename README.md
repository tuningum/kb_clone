# KB스타뱅킹 클론 (Flutter)

## 개요
KB스타뱅킹 앱의 외관을 1:1 클론한 Flutter 앱입니다.
스크린샷을 배경으로 사용하고, 금액/계좌정보를 편집할 수 있는 오버레이를 제공합니다.

## 설치 및 실행

```bash
# 1. 프로젝트 폴더로 이동
cd kb_clone

# 2. 패키지 설치
flutter pub get

# 3. 실행
flutter run
```

## 편집 모드 사용법

1. **홈 화면 아무 곳이나 3번 연속 탭** → 편집 모드 ON (파란 테두리 표시)
2. **파란 테두리 영역 탭** → 수정 다이얼로그 표시
3. **다시 3번 탭** → 편집 모드 OFF

### 편집 가능 항목
- 계좌명 (직장인우대통장-저축예금)
- 계좌번호 (567602-01-190182)
- 잔액 (5,091,862원)

## 프로젝트 구조

```
kb_clone/
├── lib/
│   ├── main.dart                 # 앱 진입점
│   ├── models/
│   │   └── app_state.dart        # 편집 가능 데이터 모델
│   ├── screens/
│   │   ├── splash_screen.dart    # 스플래시 화면
│   │   └── home_screen.dart      # 홈 화면 (메인)
│   └── widgets/
│       └── editable_overlay.dart # 편집 오버레이 위젯
├── assets/
│   └── images/
│       ├── intro1.png            # 스플래시 배경
│       ├── intro2.png            # 스플래시 로딩
│       ├── gnb.png               # 상단 네비게이션 바
│       ├── tabbar.png            # 하단 탭 바
│       ├── home_content.png      # 홈 스크롤 콘텐츠 (이어붙인 이미지)
│       ├── banner1~4.jpg         # 배너 캐러셀 이미지
│       └── (추가 화면 스크린샷)
└── pubspec.yaml
```

## 오버레이 위치 조정

스크린샷 위 오버레이 위치가 안 맞을 경우 `home_screen.dart`의 좌표값을 수정:

```dart
// 3x 픽셀 단위 (원본 스크린샷 해상도 기준)
static const double accountNameTop3x = 465;  // 계좌명 Y 위치
static const double balanceTop3x = 735;       // 잔액 Y 위치
```

## 추후 확장

- [ ] 계좌 상세 화면
- [ ] 거래내역 화면
- [ ] 이체 화면 (입력 → 확인 → 완료)
- [ ] 거래내역 편집 기능
