# 🚀 init-project

이 프로젝트는 Flutter를 기반으로 한 초기 프로젝트 설정 및 학습용 저장소입니다.

## 🛠 환경 구축 (Installation)
플루터 개발 환경을 구축하려면 아래의 상세 가이드를 참고하세요. step-by-step으로 정리되어 있습니다.

👉 [**Flutter 설치 가이드 바로가기**](https://dev-story.notion.site/Flutter-a5b039d901f849d484a2990caf4841c8)

---

## 🏗 프로젝트 구조 및 데이터 흐름 (App Architecture)

본 프로젝트는 유지보수와 협업을 위해 역할을 명확히 분리하여 설계되었습니다.

### 층별 역할 분담 (Layered Architecture)

| Layer | Folder | Description |
| :--- | :--- | :--- |
| **UI Layer** | `lib/screens/` | 사용자가 보는 화면을 구성합니다. 비즈니스 로직에 직접 관여하지 않고 입력을 전달하거나 상태를 보여주기만 합니다. |
| **Logic Layer** | `lib/providers/` | 앱의 상태(State)를 관리합니다. Service를 호출하여 데이터를 가져오고, 성공/실패 여부를 UI에 알립니다. |
| **Data Layer** | `lib/services/` | 실제 API 통신(fetch, await)을 담당합니다. 서버에 요청을 보내고 응답을 받아오는 최하단 로직입니다. |
| **Model Layer** | `lib/models/` | 서버에서 주고받는 데이터의 규격을 정의합니다. (JSON ↔ Dart Object 변환) |

### 🔄 로그인 로직 예시 (Data Flow)

| 단계 | 위치 (Folder) | 하는 일 |
| :--- | :--- | :--- |
| **1. 입력** | `lib/screens/` | 사용자가 ID/PW 입력 후 '로그인' 버튼 클릭 (UI 구성 및 입력 전달) |
| **2. 요청** | `lib/providers/` | 비즈니스 로직 수행 및 Service 호출 (로딩 상태 관리 및 데이터 요청) |
| **3. 통신** | `lib/services/` | 실제 **API 통신(fetch, await)** 수행. 서버에 HTTP 요청을 보냄 |
| **4. 변환** | `lib/models/` | 서버로부터 받은 JSON 응답 데이터를 Dart 객체(Object)로 변환 |
| **5. 저장/동기화** | `lib/providers/` | 변환된 데이터를 상태에 저장하고 앱 전체에 성공/실패 알림 |
| **6. 반응** | `lib/screens/` | 상태 변화에 따라 화면 이동(Navigator) 또는 에러 메시지 표시 |

---

## 📱 Flutter란 무엇인가요?
**Flutter**는 Google에서 만든 오픈소스 UI 소프트웨어 개발 키트(SDK)입니다. 
* **하나의 코드베이스:** Dart 언어를 사용하여 안드로이드, iOS, 웹, 데스크톱 앱을 동시에 개발할 수 있습니다.
* **고성능 UI:** 자체 렌더링 엔진을 사용하여 어떤 플랫폼에서도 부드러운 UI를 제공합니다.

## 🛠 주요 기술 스택 (Tech Stack)
* **Language:** Dart
* **Framework:** Flutter
* **State Management:** Provider (예정)
* **Network:** Http (API 통신 및 토큰 관리)
---

## 🤝 협업 가이드 (For Backend & AI)

### 🌐 Backend 담당자를 위한 Guide
* **API 통신 구조:** `lib/services/` 폴더에서 프론트엔드의 요청 방식을 확인해 주세요.
* **데이터 모델:** `lib/models/` 폴더에서 서버로부터 받을 JSON 구조를 정의합니다.

### 🤖 AI 담당자를 위한 Guide
* **데이터 전처리:** 클라이언트 단에서 가공되는 데이터 형식은 `lib/providers/`에서 확인 가능합니다.
* **결과 시각화:** AI 모델의 아웃풋이 표현될 위젯 구조를 논의할 수 있습니다.


---
## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
