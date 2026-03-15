# Story 1.2: Tích hợp FakeStore API và Xây dựng Data Models

Status: done

## Story

As a Developer,
I want xây dựng service gọi API và chuyển đổi dữ liệu thành các Product Model,
so that ứng dụng có dữ liệu thực tế để hiển thị.

## Acceptance Criteria

1. [x] API Service có khả năng thực hiện lệnh GET đến endpoint `https://fakestoreapi.com/products`.
2. [x] Dữ liệu JSON từ API phải được parse thành `ProductModel` một cách chính xác.
3. [x] Sử dụng chuẩn Dart Patterns (Sealed Classes) để quản lý 3 trạng thái của dữ liệu: `Loading`, `Success`, và `Error`.
4. [x] Toàn bộ code xử lý API phải nằm trong thư mục `/lib/services` và Models nằm trong `/lib/models`.
5. [x] Xử lý ngoại lệ (Error Handling) tốt khi có lỗi mạng hoặc lỗi parse dữ liệu.

## Tasks / Subtasks

- [x] Xây dựng Product Model (AC: 2)
  - [x] Tạo file `lib/models/product_model.dart`
  - [x] Triển khai class `ProductModel` với các thuộc tính: id, title, price, description, category, image, rating.
  - [x] Viết factory method `fromJson` cho model.
- [x] Xây dựng API State (AC: 3)
  - [x] Tạo file `lib/core/api_state.dart` (hoặc trong models) sử dụng `sealed class`.
  - [x] Định nghĩa các trạng thái: `Initial`, `Loading`, `Success<T>`, `Error`.
- [x] Triển khai API Service (AC: 1, 5)
  - [x] Tạo file `lib/services/api_service.dart`.
  - [x] Cấu hình `Dio` cho các request.
  - [x] Viết phương thức `getProducts()` trả về `List<ProductModel>` hoặc `ApiState`.
- [x] Kiểm thử tích hợp (AC: 4)
  - [x] Đảm bảo service hoạt động đúng với dữ liệu thực tế từ FakeStore.

## Dev Notes

- **Sealed Classes Example**:
  ```dart
  sealed class ApiResult<T> {}
  class ApiLoading<T> extends ApiResult<T> {}
  class ApiSuccess<T> extends ApiResult<T> { final T data; ApiSuccess(this.data); }
  class ApiError<T> extends ApiResult<T> { final String message; ApiError(this.message); }
  ```
- **Architecture Compliance**: Phải tuân thủ mô hình MVC/MVVM. Service không được chứa UI logic.
- **Naming Patterns**: Tuân thủ `snake_case.dart` cho file và `PascalCase` cho Class.

### Project Structure Notes

- Cập nhật thư mục:
  ```text
  lib/
  ├── models/
  │   └── product_model.dart
  └── services/
      └── api_service.dart
  ```

### References

- [Source: _bmad-output/planning-artifacts/architecture.md#Data Architecture]
- [Source: https://fakestoreapi.com/docs]

## Dev Agent Record

### Agent Model Used
claude-sonnet-4-6 (via BMM Create Story Workflow)

### Completion Notes List
- Phân tích yêu cầu tích hợp API từ PRD và Architecture.
- Thiết lập hướng dẫn sử dụng Dart Patterns cho quản lý trạng thái.
- Đảm bảo tính kế thừa từ Story 1.1 (cấu trúc thư mục).
- [AI-Review] Đã cập nhật ApiService sử dụng AppConstants.baseUrl thay vì hardcoded.
- [AI-Review] Đã đánh dấu hoàn thành tất cả các task.
