---
story_id: 3.1
story_key: 3-1-xay-dung-cart-provider-va-giao-dien-gio-hang-co-ban
title: Xây dựng Cart Provider và giao diện giỏ hàng cơ bản
status: done
epic: 3
---

# Story 3.1: Xây dựng Cart Provider và giao diện giỏ hàng cơ bản

## 📝 Story Description
**As a** người dùng,
**I want** quản lý giỏ hàng của mình một cách tập trung và xem các thay đổi về giá tiền/số lượng ngay lập tức,
**So that** tôi có thể kiểm soát được đơn hàng của mình trước khi thanh toán.

## ✅ Acceptance Criteria
1. **Cart State Management:**
   - [x] Sử dụng `Provider` để quản lý trạng thái giỏ hàng (Single Source of Truth).
   - [x] Không truyền dữ liệu qua tham số của `Navigator.push`.
   - [x] Badge trên biểu tượng giỏ hàng phải cập nhật ngay lập tức khi thêm/xóa sản phẩm.
2. **Logic Checkbox & Calculations:**
   - [x] Tổng tiền chỉ tính dựa trên những mục được tick Checkbox (`isChecked = true`).
   - [x] Nút "Chọn tất cả" phải đồng bộ 2 chiều (Tick All <-> Individual Items).
   - [x] Cập nhật số tiền Real-time khi nhấp vào (+) và (-).
3. **Cart Interactions:**
   - [x] Thao tác vuốt để xóa (`Dismissible`) có nền đỏ và icon thùng rác.
   - [x] Hiển thị Dialog xác nhận khi xóa sản phẩm hoặc khi số lượng giảm về 0.
4. **Data Persistence:**
   - [x] Tích hợp `shared_preferences` để lưu dữ liệu giỏ hàng offline.

## 🛠️ Tasks
- [x] **Task 1:** Tạo `CartItemModel` (id, product, quantity, size, color, isChecked).
- [x] **Task 2:** Xây dựng `CartProvider` với các methods: `addItem`, `removeItem`, `updateQuantity`, `toggleCheck`, `toggleSelectAll`.
- [x] **Task 3:** Thiết kế màn hình `CartScreen` với danh sách sản phẩm và logic Checkbox.
- [x] **Task 4:** Cập nhật `Home` và `Detail` để hiển thị `Badge` giỏ hàng lấy từ Provider.
- [x] **Task 5:** Triển khai `storage_service.dart` để persist dữ liệu giỏ hàng.

## 🏗️ Architecture Compliance
- Thư mục: `/lib/models`, `/lib/providers`, `/lib/screens/cart`.
- Định dạng tiền tệ: Sử dụng `intl` (Ví dụ: `150.000đ`).

## 📋 Dev Notes
- Hãy cẩn thận với logic sync 2 chiều của Checkbox để tránh vòng lặp trạng thái.
- Đảm bảo hiệu ứng Hero vẫn hoạt động nếu người dùng quay lại từ giỏ hàng.

## 🤖 Dev Agent Record
### Implementation Plan
- Thiết lập CartProvider kế thừa ChangeNotifier.
- Sử dụng Map trong Provider để quản lý item theo key duy nhất (ID + Thẻ chọn).
- Xây dựng CartScreen sử dụng Consumer để lắng nghe thay đổi.
- Triển khai StorageService với SharedPreferences để lưu dữ liệu JSON.

### Debug Log
- Fix lỗi disable nút (-) khi số lượng = 1 bằng cách gọi Dialog xác nhận xóa.
- Fix lỗi hardcode tỷ giá bằng cách đưa vào CurrencyUtils.

### Completion Notes
- Đã hoàn thành toàn bộ AC yêu cầu. Giỏ hàng đã có tính năng lưu offline.

## 📁 File List
- lib/models/cart_item_model.dart
- lib/providers/cart_provider.dart
- lib/screens/cart/cart_screen.dart
- lib/services/storage_service.dart
- lib/core/constants/currency_utils.dart

## 📜 Change Log
- 2026-03-15: Khởi tạo Story 3.1 chi tiết.
- 2026-03-15: Hoàn thành triển khai và fix lỗi sau Code Review.
