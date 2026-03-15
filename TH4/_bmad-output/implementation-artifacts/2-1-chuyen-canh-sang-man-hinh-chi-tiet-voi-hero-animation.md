# Story 2.1: Chuyển cảnh sang màn hình Chi tiết với Hero Animation

Status: done

## Story

As a người dùng,
I want tấm ảnh sản phẩm "bay" mượt mà từ danh sách Home sang trang Chi tiết khi tôi nhấn vào,
so that tôi cảm thấy ứng dụng cao cấp và không bị mất dấu món hàng mình vừa chọn.

## Acceptance Criteria

1. **Given** người dùng đang ở màn hình Home
2. **When** nhấn vào một thẻ sản phẩm bất kỳ
3. **Then** ứng dụng điều hướng sang màn hình Chi tiết (`ProductDetailScreen`)
4. **And** ảnh sản phẩm phải thực hiện `Hero Animation` khớp chính xác giữa hai màn hình (sử dụng thuộc tính `tag` là ID sản phẩm)
5. **And** màn hình chi tiết phải hiển thị đầy đủ thông tin sản phẩm (Tên, Giá, Mô tả, Đánh giá)

## Tasks / Subtasks

- [x] Chuẩn bị ProductDetailScreen (AC: #3, #5)
  - [x] Tạo file `lib/screens/product_detail/product_detail_screen.dart`
  - [x] Thiết kế layout hiển thị thông tin sản phẩm
- [x] Cấu hình Điều hướng (AC: #3)
  - [x] Đăng ký route cho màn hình chi tiết trong `lib/core/routes.dart`
  - [x] Xử lý truyền tham số `ProductModel` qua Navigator
- [x] Triển khai Hero Animation (AC: #4)
  - [x] Bọc ảnh sản phẩm tại `lib/widgets/common/product_card.dart` bằng widget `Hero`
  - [x] Bọc ảnh sản phẩm tại `ProductDetailScreen` bằng widget `Hero`
  - [x] Đảm bảo `tag` của Hero là duy nhất (ví dụ: `product-${product.id}`)
- [x] Xử lý format tiền tệ (AC: #5)
  - [x] Sử dụng `NumberFormat` từ `intl` để hiển thị giá theo chuẩn `###.###đ`

## Dev Notes

- **Kiến trúc:** Tuân thủ Single Source of Truth, không quản lý state riêng lẻ cho sản phẩm nếu đã có trong Provider.
- **Hero Animation:** Đảm bảo `tag` hoàn toàn giống nhau giữa 2 màn hình.
- **UI:** Sử dụng `Sliver` nếu UI yêu cầu appBar co giãn hoặc `SingleChildScrollView` cho layout đơn giản.

### Project Structure Notes

- UI màn hình: `lib/screens/product_detail/`
- Layout chi tiết: Tuân thủ cấu trúc thư mục quy định trong Architecture.

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Epic 2]
- [Source: _bmad-output/planning-artifacts/architecture.md#Frontend Architecture]
- [Source: _bmad-output/planning-artifacts/prd.md#User Journeys]

## Dev Agent Record

### Agent Model Used

Claude 3.5 Sonnet (via Agentic Workflow)

### Debug Log References

- N/A

### Completion Notes List

- Story created based on Epic 2.1 requirements.

### File List

- `lib/screens/product_detail/product_detail_screen.dart`
- `lib/core/routes.dart`
- `lib/widgets/common/product_card.dart`
