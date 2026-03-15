# Story 2-2: Lựa chọn thuộc tính sản phẩm qua BottomSheet

Status: done

## Story

As a người dùng,
I want chọn kích cỡ (Size), màu sắc và số lượng thông qua một bảng đẩy lên từ đáy màn hình thay vì chuyển sang trang mới,
so that tôi có thể tùy chỉnh nhanh chóng và quay lại xem thông tin sản phẩm dễ dàng.

## Acceptance Criteria

1. **Given** người dùng đang ở màn hình Chi tiết sản phẩm (`ProductDetailScreen`)
2. **When** nhấn nút "Chọn phân loại" hoặc "Thêm vào giỏ"
3. **Then** một `BottomSheet` phải hiện lên hiển thị:
    - Ảnh nhỏ, tên và giá sản phẩm (đã format tiền tệ)
    - Danh sách các Size (ví dụ: S, M, L, XL)
    - Danh sách các Màu sắc (hiển thị dạng hình tròn hoặc chip)
    - Bộ chọn số lượng (+ / -) với giới hạn tối thiểu là 1
4. **And** các lựa chọn (Size/Màu) phải thay đổi trạng thái UI (highlight) ngay lập tức khi nhấn
5. **And** có nút "Xác nhận" để đóng BottomSheet và hiển thị SnackBar thông báo "Đã thêm vào giỏ hàng" (tạm thời logic này sẽ được mở rộng ở Epic 3)

## Tasks / Subtasks

- [x] Thiết kế giao diện BottomSheet thuộc tính
    - [x] Tạo widget `ProductAttributesBottomSheet` trong `lib/widgets/product_detail/`
    - [x] Hiển thị thông tin tóm tắt sản phẩm ở đầu BottomSheet
    - [x] Triển khai danh sách Size/Color sử dụng `ChoiceChip` hoặc `FilterChip`
- [x] Quản lý trạng thái lựa chọn
    - [x] Xử lý logic chọn duy nhất (Single Selection) cho Size và Màu sắc
    - [x] Xử lý logic tăng/giảm số lượng (Quantity Selector)
- [x] Tích hợp vào ProductDetailScreen
    - [x] Thêm nút "Thêm vào giỏ" và "Mua ngay" tại màn hình Chi tiết
    - [x] Gọi `showModalBottomSheet` khi nhấn các nút tương ứng
- [x] Xử lý thông báo thành công
    - [x] Hiển thị `ScaffoldMessenger.showSnackBar` khi người dùng nhấn "Xác nhận" trên BottomSheet

## Dev Notes

- **UI/UX:** BottomSheet nên có `isScrollControlled: true` nếu nội dung dài. Sử dụng `BorderRadius` ở các góc trên để tạo cảm giác mềm mại.
- **State Management:** Vì đây là lựa chọn tạm thời, có thể sử dụng `StatefulBuilder` bên trong BottomSheet hoặc một `ChangeNotifier` nhỏ để quản lý UI lựa chọn.
- **Khuyến nghị:** Tham khảo logic layout từ PRD mục "User Journeys 1: Minh" để đảm bảo trải nghiệm "nhạy" (< 100ms).

## Dev Agent Record

### Agent Model Used
Claude 3.5 Sonnet (via BMAD Context Engine)

### Completion Notes
- Story created based on Epic 2 and PRD requirements.
- Linked to previous work in Story 2-1 (Product Detail foundation).

## File List
- `lib/widgets/product_detail/product_attributes_bottom_sheet.dart`
- `lib/screens/product_detail/product_detail_screen.dart` (modified)
- `lib/models/product_model.dart` (modified - business logic)
- `_bmad-output/implementation-artifacts/sprint-status.yaml` (modified)
- `_bmad-output/implementation-artifacts/2-2-lua-chon-thuoc-tinh-san-pham-qua-bottomsheet.md` (modified)
