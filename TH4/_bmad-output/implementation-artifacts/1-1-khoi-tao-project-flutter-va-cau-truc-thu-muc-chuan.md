# Story 1.1: Khởi tạo Project Flutter và Cấu trúc thư mục chuẩn

Status: done

## Story

As a Developer,
I want khởi tạo dự án Flutter với cấu trúc thư mục MVC/MVVM đã định nghĩa,
so that tôi có một nền tảng vững chắc và tuân thủ kỷ luật kiến trúc của dự án.

## Acceptance Criteria

1. [x] Môi trường phát triển Flutter đã sẵn sàng (Standard Flutter SDK v3.41).
2. [x] Project được khởi tạo với cấu trúc thư mục chuẩn: `/lib/models`, `/lib/screens`, `/lib/widgets`, `/lib/services`, `/lib/providers`.
3. [x] Cấu trúc thư mục phải khớp 100% với tài liệu Architecture (Single Source of Truth).
4. [x] Tệp `pubspec.yaml` phải bao gồm các thư viện cụ thể: `provider`, `intl`, `http` hoặc `dio`.
5. [x] Thiết lập định dạng tiền tệ chuyên nghiệp (`###.###đ`) ngay từ đầu trong hệ thống constants/utils.

## Tasks / Subtasks

- [x] Khởi tạo project Flutter (AC: 1)
  - [x] Chạy lệnh `flutter create --org com.nhom[SoNhom] --project-name th4 .`
- [x] Thiết lập cấu trúc thư mục (AC: 2, 3)
  - [x] Tạo `lib/models/`, `lib/screens/`, `lib/widgets/`, `lib/services/`, `lib/providers/`
  - [x] Tạo các thư mục con trong `lib/core/` (constants, routes)
- [x] Cấu hình dependencies (AC: 4)
  - [x] Thêm `provider: ^6.1.5+1`
  - [x] Thêm `intl: ^0.20.2`
  - [x] Thêm `dio: ^5.9.2` hoặc `http: ^1.6.0`
- [x] Thiết lập Routing cơ bản và Provider gốc (AC: 5)
  - [x] Cấu hình `lib/main.dart` với `MultiProvider`
  - [x] Tạo `lib/core/routes.dart` với 4 Named Routes chính (Home, Detail, Cart, Orders)

## Dev Notes

- **Architecture Compliance**: Phải tuân thủ mô hình MVC/MVVM. Không viết logic trong Screen.
- **Naming Patterns**:
  - File: `snake_case.dart`
  - Class: `PascalCase`
  - Method/Var: `camelCase`
- **Critical Warning**: 🚫 CẤM dùng `Navigator.push` để truyền dữ liệu giỏ hàng. Phải dùng Provider.
- **Currency**: Bắt buộc dùng `NumberFormat` từ `intl`.

### Project Structure Notes

- Cấu trúc thư mục mục tiêu:
  ```text
  lib/
  ├── core/ (constants, routes)
  ├── models/ (product, cart_item)
  ├── providers/ (product, cart)
  ├── screens/ (home, detail, cart, orders)
  ├── services/ (api, storage)
  └── widgets/ (common components)
  ```

### References

- [Source: _bmad-output/planning-artifacts/architecture.md#Project Structure]
- [Source: _bmad-output/project-context.md#Critical Implementation Rules]

## Dev Agent Record

### Agent Model Used
claude-sonnet-4-6 (via BMM Create Story Workflow)

### Completion Notes List
- Ultimate context engine analysis completed - comprehensive developer guide created.
- Latest versions of libraries researched (March 2026).
- [AI-Review] Đã sửa lỗi SDK version lên ^3.41.0.
- [AI-Review] Đã bổ sung CurrencyUtils cho định dạng tiền tệ VND.
- [AI-Review] Đã dọn dẹp thư mục core/routes thừa.
