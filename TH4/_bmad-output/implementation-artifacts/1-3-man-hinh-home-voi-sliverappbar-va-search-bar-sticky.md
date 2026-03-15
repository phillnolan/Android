# Story 1.3: Màn hình Home với SliverAppBar và Search Bar "Sticky"

Status: done

## Story

As a người dùng,
I want thấy một thanh tìm kiếm luôn hiển thị ở đầu trang và Carousel banner bắt mắt,
so that tôi có thể dễ dàng tìm kiếm sản phẩm và xem các chương trình khuyến mãi.

## Acceptance Criteria

1. [x] Sử dụng `SliverAppBar` cho màn hình Home, nền chuyển từ trong suốt sang màu chủ đạo khi cuộn xuống.
2. [x] `SearchBar` phải được tích hợp trong AppBar với cơ chế "Sticky" (luôn dính ở đỉnh khi cuộn).
3. [x] Banner quảng cáo hiển thị qua `CarouselSlider` có tính năng tự động chạy và có `Dots Indicator`.
4. [x] Danh mục sản phẩm hiển thị dạng `GridView` với 2 hàng ngang biểu tượng.
5. [x] Danh sách sản phẩm chính hiển thị dưới dạng lưới (2 cột) với `Product Card` chứa:
   - Ảnh sản phẩm (có Hero Animation placeholder).
   - Tên sản phẩm giới hạn 2 dòng (ellipses).
   - Giá tiền định dạng chuẩn `###.###đ`.
   - Badge giỏ hàng ở góc phải AppBar phải hiển thị số lượng sản phẩm thực tế từ Provider.
6. [x] Hiển thị hiệu ứng `Shimmer` khi tải dữ liệu từ API (kế thừa từ Story 1.2).

## Tasks / Subtasks

- [x] Xây dựng khung giao diện Home với CustomScrollView (AC: 1, 2)
  - [x] Triển khai `SliverAppBar` và `SliverPersistentHeader` cho Search Bar dính.
  - [x] Cấu hình logic đổi màu AppBar theo offset cuộn.
- [x] Triển khai Section Banner (AC: 3)
  - [x] Sử dụng thư viện `carousel_slider`.
  - [x] Tạo widget `BannerSlider` với dots indicator.
- [x] Triển khai Section Danh mục (AC: 4)
  - [x] Tạo `CategoryGrid` hỗ trợ cuộn ngang hoặc lưới cố định 2 hàng.
- [x] Triển khai Product Grid & Card (AC: 5, 6)
  - [x] Tạo Widget `ProductCard` dùng chung.
  - [x] Tích hợp `ApiService` (đã xong ở 1.2) để hiển thị dữ liệu thực tế.
  - [x] Sử dụng `Shimmer` khi `ApiState` ở trạng thái `Loading`.
- [x] Kết nối trạng thái Giỏ hàng (AC: 5)
  - [x] Hiển thị Badge giỏ hàng trên AppBar sử dụng `Consumer<CartProvider>`.

## Dev Notes

- **Widget Separation**: Tách các phần Header, Banner, Categories thành các widget riêng trong thư mục `/lib/widgets/home/`.
- **Hero Animation**: Bao bọc ảnh sản phẩm trong widget `Hero` with tag là `product.id`.
- **State Integration**: Sử dụng `ProductProvider` (cần tạo) để gọi `ApiService` và quản lý trạng thái hiển thị.
- **Constraints**: ⚠️ Tuyệt đối không dùng Navigator.push để truyền data giỏ hàng.

### Project Structure Notes

- Cập nhật thư mục:
  ```text
  lib/
  ├── screens/home/
  │   └── home_screen.dart
  ├── widgets/
  │   ├── home/ (banners, grids)
  │   └── common/ (product_card, shimmer)
  └── providers/
      └── product_provider.dart
  ```

### References

- [Source: _bmad-output/planning-artifacts/architecture.md#Frontend Architecture]
- [Source: _bmad-output/project-context.md#Home Screen Rules]

## Dev Agent Record

### Agent Model Used
claude-sonnet-4-6 (via BMM Create Story Workflow)

### Completion Notes List
- Thiết lập yêu cầu chi tiết cho UI màn hình Home linh hoạt với Sliver.
- Tích hợp các ràng buộc UX từ project-context (Badge, Sticky Search, 2-line title).
- Sẵn sàng tích hợp dữ liệu từ ApiService đã hoàn thành.
- [AI-Review] Đã cập nhật ProductCard dùng CurrencyUtils.formatVND và Shimmer loading cho ảnh.
- [AI-Review] Đã thay Navigator string bằng AppRoutes.cart để đảm bảo an toàn.
- [AI-Review] Đã đánh dấu Story 1.3 là hoàn thành.
