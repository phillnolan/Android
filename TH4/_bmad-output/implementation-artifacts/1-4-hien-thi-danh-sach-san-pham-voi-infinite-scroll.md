# Story 1.4: Hiển thị Danh sách sản phẩm với Infinite Scroll

Status: done

## Story

As a người dùng,
I want xem danh sách sản phẩm tải thêm liên tục khi cuộn xuống và có hiệu ứng loading,
so that tôi có thể khám phá hàng trăm sản phẩm mà không bị gián đoạn.

## Acceptance Criteria

1. [x] **Given** danh sách sản phẩm có nhiều hơn 10 item, **When** người dùng cuộn đến cuối danh sách, **Then** ứng dụng phải tự động gọi API để tải trang tiếp theo.
2. [x] **And** hiển thị hiệu ứng `Shimmer` hoặc `CircularProgressIndicator` ở cuối danh sách trong khi chờ dữ liệu trang tiếp theo.
3. [x] **And** hỗ trợ tính năng **Pull-to-refresh** (RefreshIndicator) để làm mới toàn bộ danh sách sản phẩm từ đầu.
4. [x] **And** dữ liệu mới tải về phải được nối tiếp (append) vào danh sách hiện tại trong `ProductProvider` mà không làm mất trạng thái cuộn.

## Tasks / Subtasks

- [x] **Task 1: Cập nhật Service & Provider cho Pagination (AC: 1, 4)**
  - [x] Thêm tham số `page` hoặc `limit/offset` vào `ApiService.getProducts`.
  - [x] Cập nhật `ProductProvider` để lưu trữ danh sách sản phẩm hiện tại và trạng thái `isLoadingMore`.
  - [x] Viết method `fetchMoreProducts()` trong Provider để gọi API và merge dữ liệu mới.
- [x] **Task 2: Triển khai Infinite Scroll tại HomeScreen (AC: 1)**
  - [x] Gán `ScrollController` vào `CustomScrollView` hoặc `SliverList/Grid`.
  - [x] Lắng nghe sự kiện cuộn (listener) để phát hiện khi người dùng gần chạm đáy (80-90% trang).
  - [x] Gọi `fetchMoreProducts()` khi điều kiện thỏa mãn và không trong trạng thái loading.
- [x] **Task 3: UI Loading & Refresh Controls (AC: 2, 3)**
  - [x] Implement `RefreshIndicator` bao bọc lấy `CustomScrollView`.
  - [x] Thêm một Sliver/Widget ở cuối danh sách để hiển thị `Shimmer` khi `isLoadingMore == true`.
- [x] **Task 4: Tối ưu hóa hiệu suất & UX**
  - [x] Đảm bảo không gọi duplicate API khi đang loading.
  - [x] Kiểm tra logic "No more data" và hiển thị thông báo cuối danh sách.

## Dev Notes

- **Architecture Compliance:**
  - Tuyệt đối xử lý logic data tại `ProductProvider`, UI chỉ lắng nghe và hiển thị.
  - Sử dụng `intl` để format giá tiền trên các Product Card mới tải vê.
- **Source tree components:**
  - `lib/providers/product_provider.dart`
  - `lib/screens/home/home_screen.dart`
  - `lib/services/api_service.dart`
- **Testing standards:**
  - Kiểm tra trạng thái mạng yếu để đảm bảo Shimmer hiển thị đúng vị trí.
  - Kiểm tra Pull-to-refresh có xóa danh sách cũ và tải lại từ trang 1 hay không.

### Project Structure Notes

- Tuân thủ `/lib/providers` cho State Management.
- Product Card widget được tái sử dụng từ `lib/widgets/common/product_card.dart`.

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story 1.4]
- [Source: _bmad-output/project-context.md#Framework-Specific Rules]
- [API: FakeStore API `/products?limit=...`]

## Dev Agent Record

### Agent Model Used
Claude 4.6 Sonnet (BMAD Instance)

### Completion Notes List
- Triển khai thành công logic Infinite Scroll với ScrollController.
- Tích hợp RefreshIndicator mượt mà.
- [AI-Review] Bổ sung thông báo "Bạn đã xem hết sản phẩm rồi" ở cuối danh sách để cải thiện UX.
- [AI-Review] Đính chính đường dẫn ProductCard trong tài liệu.
- [AI-Review] Đã đánh dấu Story 1.4 là hoàn thành.
