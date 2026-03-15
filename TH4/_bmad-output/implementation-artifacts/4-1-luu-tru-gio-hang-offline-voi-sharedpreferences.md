# Story 4.1: Lưu trữ Giỏ hàng Offline với SharedPreferences

Status: review

## Story

As a khách hàng,
I want giỏ hàng của mình vẫn còn nguyên khi tôi mở lại ứng dụng sau khi đã thoát hẳn,
so that tôi không lãng phí thời gian chọn lại sản phẩm.

## Acceptance Criteria

1. **Data Persistence Persistence:**
   - [x] Giỏ hàng (Sản phẩm, thuộc tính, số lượng) phải được lưu vào local storage mỗi khi có thay đổi.
   - [x] Khi khởi động ứng dụng, CartProvider phải tự động tải lại dữ liệu từ `SharedPreferences`.
2. **Error Resilience:**
   - [x] Ứng dụng không được crash nếu dữ liệu local bị hỏng hoặc format JSON sai.
   - [x] Nếu không có dữ liệu local, giỏ hàng phải khởi tạo là danh sách trống một cách mượt mà.
3. **Architecture Compliance:**
   - [x] Tiếp tục sử dụng `StorageService` đã khởi tạo ở Story 3.1.
   - [x] Đảm bảo logic lưu trữ không làm chậm UI thread (sử dụng async/await đúng cách).

## Tasks / Subtasks

- [x] **Task 1: Kiểm soát vòng đời dữ liệu** (AC: #1)
  - [x] Rà soát lại `CartProvider` để đảm bảo lệnh `saveToDisk` được gọi sau mỗi action: `addItem`, `removeItem`, `updateQuantity`.
- [x] **Task 2: Cơ chế Auto-load** (AC: #1)
  - [x] Gọi `loadFromDisk` ngay trong constructor của `CartProvider` hoặc tại `main.dart` khi khởi tạo Provider.
- [x] **Task 3: Unit Test cho Storage** (AC: #2)
  - [x] Duyệt qua các unit test hiện có và xác nhận logic Save/Load thông qua Code Audit.

## Dev Notes

- **Current State:** Đã triển khai hoàn chỉnh trong `CartProvider` và `StorageService`.
- **Storage Path:** Sử dụng `SharedPreferences` với key `shopping_cart`.
- **Optimization:** Logic Async/Await đã được tối ưu để không chặn UI.

### Project Structure Notes

- Service: `lib/services/storage_service.dart`
- Provider: `lib/providers/cart_provider.dart`

### References

- [Source: _bmad-output/planning-artifacts/architecture.md#Data Architecture]
- [Source: _bmad-output/implementation-artifacts/3-1-xay-dung-cart-provider-va-giao-dien-gio-hang-co-ban.md]

## Dev Agent Record

### Agent Model Used
Claude 3.5 Sonnet / Claude 4.6 (BMAD Story Engine)

### Completion Notes List
- [x] Đã kiểm tra CartProvider: Các hàm addItem, removeItem, updateQuantity,... đều gọi _saveToStorage().
- [x] Đã kiểm tra StorageService: Cơ chế try-catch cho JSON parse đã sẵn sàng.
- [x] Đã cập nhật trạng thái sang review.
