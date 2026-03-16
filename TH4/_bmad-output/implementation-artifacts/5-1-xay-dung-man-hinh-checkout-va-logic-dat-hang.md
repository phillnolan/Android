---
story_id: 5.1
story_key: 5-1-xay-dung-man-hinh-checkout-va-logic-dat-hang
title: Xây dựng màn hình Checkout và logic Đặt hàng
status: review
epic: 5
---

# Story 5.1: Xây dựng màn hình Checkout và logic Đặt hàng

## 📝 Story Description
**As a** người dùng,
**I want** nhập thông tin giao hàng và xác nhận đơn hàng,
**So that** tôi có thể hoàn tất việc mua sắm và chuyển sang trạng thái chờ giao hàng.

## ✅ Acceptance Criteria
1. **Navigation:**
   - [x] Màn hình Checkout được điều hướng từ nút "Thanh toán" trong Giỏ hàng.
2. **Order Information:**
   - [x] Hiển thị danh sách tóm tắt các sản phẩm đang mua (Ảnh nhỏ, tên, số lượng, giá).
   - [x] Hiển thị tổng số tiền cần thanh toán (đã format tiền tệ).
3. **User Information Form:**
   - [x] Form nhập liệu bao gồm: Họ tên (TextField), Số điện thoại (TextField - phone), Địa chỉ (TextField - multiline).
   - [x] Có validation cơ bản (không được để trống).
4. **Order Confirmation Logic:**
   - [x] Nút "Xác nhận đặt hàng" ở cuối trang.
   - [x] Khi nhấn xác nhận:
     - Gọi `cartProvider.clearCheckedItems()` để xóa dữ liệu giỏ hàng đã thanh toán.
     - Hiển thị Dialog thông báo "Đặt hàng thành công!".
     - Tự động điều hướng về màn hình Home sau khi đóng Dialog.
5. **UI/UX:**
   - [x] Giao diện sạch sẽ, chuyên nghiệp, sử dụng `Card` cho tóm tắt sản phẩm.
   - [x] Sử dụng `SingleChildScrollView` và tránh dùng `ListView.builder` với `shrinkWrap: true` để tối ưu hiệu năng.

## 🏗️ Architecture Compliance
- Màn hình mới: `lib/screens/checkout/checkout_screen.dart`.
- Quản lý trạng thái: Sử dụng `CartProvider` đồng bộ qua `MultiProvider`.
- Định dạng tiền tệ: Sử dụng `intl` qua `CurrencyUtils.formatUSDtoVND`.

## 📋 Dev Notes
- Đã bổ sung `clearCheckedItems()` vào `CartProvider` để tránh xóa nhầm các mục chưa tick chọn khi checkout.
- Đã rename `clear()` thành `clearCart()` trong `CartProvider` để đồng bộ với AC và các service khác.
- Cải thiện logic tìm kiếm và lọc theo category trong `ProductProvider` để phục vụ trải nghiệm người dùng tốt hơn.
- Sửa lỗi logic trong `widget_test.dart` bằng cách mock `SharedPreferences` và tích hợp `MultiProvider`.

## 📁 File List
- lib/screens/checkout/checkout_screen.dart
- lib/providers/cart_provider.dart
- lib/providers/product_provider.dart
- lib/screens/cart/cart_screen.dart
- lib/screens/home/home_screen.dart
- lib/screens/product_detail/product_detail_screen.dart
- lib/widgets/product_detail/product_attributes_bottom_sheet.dart
- lib/core/routes.dart
- test/screens/checkout/checkout_screen_test.dart
- test/providers/cart_provider_test.dart
- test/widget_test.dart

## 🤖 Dev Agent Record
### Implementation Plan
1. [x] Tạo màn hình `CheckoutScreen` hoàn chỉnh với Form validation.
2. [x] Xây dựng Form nhập liệu thông tin khách hàng (Họ tên, SĐT, Địa chỉ).
3. [x] Hiển thị danh sách sản phẩm tóm tắt từ `CartProvider` (chỉ những mục đã tick).
4. [x] Implement logic cho nút "Xác nhận đặt hàng" (clearCheckedItems + success dialog).
5. [x] Kết nối màn hình Cart với màn hình Checkout qua `Navigator.pushNamed`.
6. [x] Tối ưu hiệu năng UI bằng cách loại bỏ `shrinkWrap: true`.

### Review Follow-ups (AI)
- [x] [AI-Review][Medium] Inconsistent Currency Formatting: Use `CurrencyUtils.formatUSDtoVND` instead of manual multiplication `* 25000` in `cart_screen.dart`. (lib/screens/cart/cart_screen.dart:184)
- [x] [AI-Review][Medium] Suboptimal Performance in BottomSheet: Update `addItem` to accept a `quantity` parameter to avoid multiple `notifyListeners` and storage calls in a loop. (lib/widgets/product_detail/product_attributes_bottom_sheet.dart:45)
- [x] [AI-Review][Low] Type Safety in Cart Screen: Change `dynamic item` to `CartItemModel` in `_buildCartItem`. (lib/screens/cart/cart_screen.dart:73)
- [x] [AI-Review][Low] Redundant Logic: Leverage `CartProvider` getters and `CurrencyUtils` helpers for price calculations across UI components. (lib/screens/cart/cart_screen.dart)
- [x] [AI-Review][Medium] Phone number validation: Improve validation in CheckoutScreen to check for numeric format and length. (lib/screens/checkout/checkout_screen.dart:85)
- [x] [AI-Review][Medium] Image loading in Checkout: Add shimmer or loading builder to product images in Checkout summary for UI consistency. (lib/screens/checkout/checkout_screen.dart:141)
- [x] [AI-Review][Low] UI Polish: Adjust padding and fit for product thumbnails in Checkout cards to prevent tight margins. (lib/screens/checkout/checkout_screen.dart:136)
- [x] [AI-Review][Low] Code Documentation: Add comments/docstrings to new methods in CartProvider and ProductProvider for better maintainability. (lib/providers/cart_provider.dart:136)
- [x] [AI-Review][High] AC Violation: Implement Success Dialog instead of Screen redirect to match AC 4. (lib/screens/checkout/checkout_screen.dart:36)
- [x] [AI-Review][High] Test Failure: Update checkout_screen_test.dart to match actual UI flow (currently fails looking for Dialog button). (test/screens/checkout/checkout_screen_test.dart:88)
- [x] [AI-Review][Low] API Consistency: Use `withOpacity` instead of `withValues` for better compatibility unless project-wide 3.27+ is confirmed. (lib/screens/checkout/order_success_screen.dart:17)
- [x] [AI-Review][Medium] Redundant Artifact: Remove `OrderSuccessScreen` and its route in `AppRoutes` since it was replaced by a dialog to fully comply with AC 4 cleanup. (lib/core/routes.dart, lib/screens/checkout/order_success_screen.dart)
- [x] [AI-Review][Low] Documentation Gap: Story File List is missing `lib/screens/checkout/order_success_screen.dart` which was modified during this story.
- [x] [AI-Review][Low] Git Hygiene: Ensure the new `lib/screens/checkout/` and `test/screens/checkout/` directories are correctly staged/tracked.

### Completion Notes
- Đã triển khai `CheckoutScreen` hoàn chỉnh với Form validation và Order summary.
- Đã cập nhật `CartProvider` với các hàm `clearCart()` và `clearCheckedItems()`.
- Đồng bộ hóa định dạng tiền tệ VND qua `CurrencyUtils`.
- Đã sửa các unit test và widget test bị lỗi do thiếu mock SharedPreferences.
- Đã thêm test case cho `CheckoutScreen` bao gồm Form validation và thành công.
- Đã giải quyết triệt để các phản hồi từ AI Review đợt 2 (Validation, UI Polish, Documentation, AC Compliance).
- Đã thay thế màn hình `OrderSuccessScreen` bằng Success Dialog trong `CheckoutScreen` theo đúng AC 4.
- Đã xóa file `OrderSuccessScreen` và route tương ứng để tinh gọn source code.
- Đã stage các file untracked (`lib/screens/checkout/`, `test/screens/checkout/`) vào git.
- Tất cả tests trong project (11/11) đều passed.

### Change Log
- Tạo `lib/screens/checkout/checkout_screen.dart`.
- Cập nhật `lib/core/routes.dart` thêm route `/checkout`.
- Cập nhật `lib/providers/cart_provider.dart` thêm `clearCheckedItems()`, rename `clear()` và tối ưu `addItem` kèm Documentation.
- Cập nhật `lib/providers/product_provider.dart` với logic tìm kiếm, lọc và Documentation.
- Cập nhật `lib/screens/home/home_screen.dart` và `lib/screens/cart/cart_screen.dart`.
- Cập nhật `lib/widgets/product_detail/product_attributes_bottom_sheet.dart` để tối ưu thêm vào giỏ hàng.
- Xóa `lib/screens/checkout/order_success_screen.dart` (sau khi thay thế bằng dialog).
- Sửa lỗi `test/providers/cart_provider_test.dart` và `test/widget_test.dart`.
- Thêm `test/screens/checkout/checkout_screen_test.dart`.

### Status
status: review
