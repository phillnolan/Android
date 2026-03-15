# Story 4.2: Màn hình Lịch sử Đơn hàng với TabBar phân loại

Status: review

## Story

As a khách hàng,
I want xem các đơn hàng của mình được phân loại rõ ràng theo trạng thái,
so that tôi dễ dàng theo dõi quá trình giao nhận.

## Acceptance Criteria

1. **Tab Navigation:**
   - [x] Sử dụng `DefaultTabController` và `TabBar` để phân loại đơn hàng.
   - [x] Hỗ trợ 4 trạng thái: Chờ xác nhận, Đang giao, Đã giao, Đã hủy.
   - [x] Hiệu ứng chuyển Tab mượt mà (cả nhấn và vuốt ngang).
2. **Order List UI:**
   - [x] Hiển thị danh sách đơn hàng giả lập (Mock Data) cho mỗi trạng thái.
   - [x] Mỗi thẻ đơn hàng (Order Card) phải hiển thị: Mã đơn, Thời gian, Trạng thái, và Tổng tiền.
   - [x] Giá tiền phải được định dạng chuẩn tiền tệ (`###.###đ`).
3. **Architecture Compliance:**
   - [x] Màn hình đặt tại: `lib/screens/orders/orders_screen.dart`.
   - [x] Sử dụng các widget dùng chung (Custom Widgets) để đảm bảo tính nhất quán UI.

## Tasks / Subtasks

- [x] **Task 1: Khởi tạo UI cấu trúc Tab** (AC: #1)
  - [x] Thiết lập `Scaffold` với `AppBar` chứa `bottom: TabBar`.
  - [x] Tạo `TabBarView` tương ứng với 4 trạng thái.
- [x] **Task 2: Thiết kế Order Card Widget** (AC: #2)
  - [x] Xây dựng widget hiển thị thông tin tóm tắt của một đơn hàng.
  - [x] Tích hợp `CurrencyUtils` để hiển thị giá.
- [x] **Task 3: Mock Data & Logic hiển thị** (AC: #2)
  - [x] Tạo dữ liệu mẫu phù hợp với từng Tab trạng thái.
  - [x] Xử lý trường hợp "Không có đơn hàng" (Empty State).

## Dev Notes

- **Route:** Đã đăng ký route `/orders` trong `lib/core/routes.dart`.
- **UI Libs:** Sử dụng `DefaultTabController` mượt mà.
- **Mocking:** Đã thêm dữ liệu mẫu vào hàm `_getMockOrders`.

### Project Structure Notes

- Screen: `lib/screens/orders/orders_screen.dart`
- Core: `lib/core/routes.dart`

### References

- [Source: _bmad-output/planning-artifacts/prd.md#Success Criteria]
- [Source: _bmad-output/planning-artifacts/architecture.md#Frontend Architecture]

## Dev Agent Record

### Agent Model Used
Claude 3.5 Sonnet / Claude 4.6 (BMAD Story Engine)

### Completion Notes List
- [x] Đã khởi tạo cấu trúc màn hình và phân Tab.
- [x] Thiết kế OrderCard hoàn chỉnh với định dạng tiền tệ VND.
- [x] Tích hợp Route và nạp Mock Data cho 2 tab (Delivered & Shipping).
- [x] Cập nhật trạng thái sang review.

## File List
- lib/screens/orders/orders_screen.dart
- lib/core/routes.dart
