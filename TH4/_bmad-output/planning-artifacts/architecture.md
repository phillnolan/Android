---
stepsCompleted: [1, 2, 3, 4, 5, 6, 7, 8]
workflowType: 'architecture'
lastStep: 8
status: 'complete'
project_name: 'TH4'
user_name: 'Nguyên'
date: '2026-03-15'
completedAt: '2026-03-15'
---

# Architecture Decision Document - TH4

_Tài liệu này là "nguồn sự thật duy nhất" (Single Source of Truth) cho tất cả các quyết định kỹ thuật, đảm bảo việc triển khai nhất quán trong suốt vòng đời phát triển dự án._

## Project Context Analysis

### Requirements Overview

**Functional Requirements:**
- **Màn hình chính (Home):** UI phức tạp với SliverAppBar sticky, Search bar, Carousel banner, và GridView đa tầng. Hỗ trợ Infinite Scrolling và Pull-to-refresh.
- **Chi tiết sản phẩm (Product Detail):** Sử dụng Hero Animation để chuyển cảnh, tích hợp BottomSheet để chọn thuộc tính sản phẩm (màu sắc, kích thước, số lượng) thay vì chuyển màn hình form.
- **Giỏ hàng (Cart):** Quản lý trạng thái phức tạp với logic Checkbox đồng bộ 2 chiều, tính toán tổng tiền Real-time, và thao tác vuốt để xóa (Dismissible).
- **Lịch sử đơn hàng:** Sử dụng TabView/TabBar để phân loại trạng thái đơn hàng (Chờ xác nhận, Đang giao, v.v.).

**Non-Functional Requirements:**
- **Performance (Hiệu suất):** Cập nhật giá trị giỏ hàng phải đạt tốc độ phản hồi < 100ms.
- **Data Integrity (Toàn vẹn dữ liệu):** Định dạng tiền tệ chính xác (`150.000đ`), quản lý trạng thái tập trung (Single Source of Truth) cho giỏ hàng.
- **Persistence (Lưu trữ):** Hỗ trợ lưu trữ giỏ hàng Offline (SharedPreferences/Firebase) để bảo toàn dữ liệu khi tắt app.
- **UX Consistency:** Sử dụng hiệu ứng mượt mà (Hero, Shimmer, SnackBar) để tăng cảm nhận cao cấp cho ứng dụng.

**Scale & Complexity:**
- Dự án có độ phức tạp trung bình (Medium), tập trung sâu vào quản lý trạng thái (State Management) và tương tác UI nâng cao.

- Primary domain: Mobile Application (Flutter)
- Complexity level: Medium
- Estimated architectural components: ~12-15 components (Controllers/Providers, Models, Screens, Shared Widgets, Services)

### Technical Constraints & Dependencies

- **Dependencies:** Flutter SDK, FakeStore API, SharedPreferences/Firebase, Provider/GetX.
- **Constraints:** Tuyệt đối cấm truyền dữ liệu Giỏ hàng thủ công qua `Navigator.push`. Yêu cầu chia nhánh Git theo thành viên và tuân thủ định dạng báo cáo (video demo chuyên nghiệp).

### Cross-Cutting Concerns Identified

- **State Management:** Quản lý trạng thái Giỏ hàng xuyên suốt toàn bộ ứng dụng.
- **Error Handling:** Xử lý ngoại lệ khi gọi FakeStore API và hiển thị trạng thái trống (Empty State).
- **Formatting:** Logic định dạng tiền tệ dùng chung cho toàn app để đảm bảo tính chuyên nghiệp.
- **Navigation:** Luồng chuyển cảnh đồng nhất sử dụng Hero Animation.

## Starter Template Evaluation

### Selected Starter: Standard Flutter SDK (Version 3.41)

**Rationale for Selection:**
- Đảm bảo tuân thủ 100% cấu trúc thư mục bắt buộc trong `project-context.md`.
- Tránh các boilerplate không cần thiết từ các framework bên thứ ba, giúp tập trung vào logic bài tập (Checkbox sync, BottomSheet selection).

**Initialization Command:**
```bash
flutter create --org com.nhom[SoNhom] --project-name th4 .
```

## Core Architectural Decisions

### Data Architecture
- **Database/Persistence:** `shared_preferences` (v2.3.0+) để lưu trữ giỏ hàng Offline.
- **Data Modeling:** Sử dụng Dart Patterns (Sealed Classes) để quản lý trạng thái API (Result: Success, Loading, Error).

### Frontend Architecture
- **State Management:** `provider` (v6.1.0+). Quản lý Single Source of Truth cho Cart State.
- **Routing:** `Navigator 2.0` với Named Routes để quản lý 4 màn hình chính.

## Implementation Patterns & Consistency Rules

### Naming Patterns
- **Files:** `snake_case.dart` (Ví dụ: `data_persistence_service.dart`).
- **Classes:** `PascalCase` (Ví dụ: `CartItemModel`).
- **Methods/Variables:** `camelCase` (Ví dụ: `updateQuantity`).

### Structure Patterns
- **Project Grid:** Tuân thủ cấu trúc thư mục: `/lib/models`, `/lib/screens`, `/lib/widgets`, `/lib/services`, `/lib/providers`.
- **Logic Separation:** Không viết logic tính toán giá tiền hoặc xử lý API trực tiếp trong file Screen (UI).

### Format Patterns
- **Currency:** Bắt buộc dùng `NumberFormat` từ gói `intl` để định dạng `###.###đ`.

## Project Structure & Boundaries

### Complete Project Directory Structure
```text
th4/
├── lib/
│   ├── main.dart
│   ├── core/
│   │   ├── constants/
│   │   └── routes.dart
│   ├── models/
│   │   ├── product_model.dart
│   │   └── cart_item_model.dart
│   ├── screens/
│   │   ├── home/
│   │   ├── product_detail/
│   │   ├── cart/
│   │   └── orders/
│   ├── widgets/
│   ├── services/
│   │   ├── api_service.dart
│   │   └── storage_service.dart
│   └── providers/
│       ├── product_provider.dart
│       └── cart_provider.dart
```

## Architecture Validation Results

### Coherence Validation ✅
- **Status:** READY FOR IMPLEMENTATION
- **Confidence Level:** High

### Implementation Handoff
- **Bước ưu tiên 1:** Khởi tạo project bằng lệnh `flutter create` và thiết lập `pubspec.yaml`.
- **Hướng dẫn cho AI Agent:** Tuyệt đối tuân thủ cấu trúc `/lib/providers` cho logic giỏ hàng. Cấm sử dụng `setState` cho dữ liệu dùng chung.
