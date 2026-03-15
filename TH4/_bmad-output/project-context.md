---
project_name: 'TH4'
user_name: 'Nguyên'
date: '2026-03-15'
sections_completed: ['technology_stack', 'framework_specific', 'code_quality_and_workflow', 'critical_dont_miss']
existing_patterns_found: 5
---

# Project Context for AI Agents

_This file contains critical rules and patterns that AI agents must follow when implementing code in this project. Focus on unobvious details that agents might otherwise miss._

---

## Technology Stack & Versions

- **Framework:** Flutter (SDK: flutter)
- **Language:** Dart (SDK: ^3.11.1)
- **UI Libraries:**
  - Material Design (uses-material-design: true)
  - `cupertino_icons` (^1.0.8)
- **Architecture Pattern:** Bắt buộc áp dụng MVC hoặc MVVM.
  - Cấu trúc thư mục tối thiểu phải có: `models/`, `screens/`, `widgets/` (chứa các thành phần dùng chung như custom buttons, cards), `services/` (gọi API/Firebase), và `providers/` (hoặc `controllers/` nếu dùng GetX).
- **State Management:** Bắt buộc sử dụng Provider, GetX, hoặc thư viện tương đương để quản lý trạng thái liên màn hình.
- **Data Persistence:** Ưu tiên SharedPreferences hoặc Firebase để lưu trữ dữ liệu offline (Cart Data).
- **Network Data:** Khuyên dùng FakeStore API.

## Critical Implementation Rules

### Framework-Specific Rules (UI/UX Flutter Rules)

- **Home Screen (Trang chủ):**
  - Sub-header/Identifier (chữ viết trong AppBar chính): `TH4 - Nhóm [Số nhóm]`.
  - Bắt buộc sử dụng `SliverAppBar` với thanh Search dính (sticky) ở đỉnh và đổi màu nền khi cuộn xuống (từ trong suốt sang màu chủ đạo).
  - Góc phải trên cùng (Actions) phải có Giỏ hàng với Badge (chấm đỏ hiện tổng số loại sản phẩm).
  - Cấu trúc layout dưới AppBar:
    - Banner quảng cáo với Auto-play Carousel Slider có chấm (dots indicator).
    - GridView cho danh mục (2 hàng ngang biểu tượng).
    - Lưới GridView (2 cột) hoặc Masonry grid để hiển thị Product Card.
  - Thẻ sản phẩm (Product Card):
    - Giới hạn tên 2 dòng (cắt bằng dấu ...).
    - Ảnh phải có loading mở (FadeInImage / Shimmer effect).
    - Tag nổi bật.
  - Hỗ trợ cơ chế Pull-to-Refresh & Infinite Scrolling (Pagination API).
  - Nhấp vào ảnh sản phẩm sẽ áp dụng Hero Animation chuyển sang Product Detail.

- **Product Details (Chi tiết Sản phẩm):**
  - Giao diện có Slider Ảnh, Khối hiển thị Giá/Tên, khối chọn phân loại, và văn bản mô tả mở rộng (RichText).
  - Bottom Navigation Bar cố định đáy chứa 2 nhóm chức năng (Chat/Cart icon và Nút Add to Cart/Mua ngay).
  - Thay vì chuyển đổi form, dùng **BottomSheet** đẩy lên từ đáy để chọn màu sắc, kích thước và số lượng khi nhấp "Thêm vào giỏ".
  - Hoàn tất qua SnackBar (`Thêm thành công`) kèm hiệu ứng nảy số ngay lập tức trên Badge giỏ hàng mà không chuyển context màn hình.

- **Cart Screen (Danh sách Giỏ hàng):**
  - Chỉ tính tổng tiền cho những mục được tick Checkbox.
  - Cập nhật số tiền Real-time khi nhấp vào (+) và (-).
  - Nếu số lượng trừ về 0, hiển thị hội thoại (`Bạn có muốn xóa không?`).
  - Phải có nút chọn "Tất cả" liên kết trạng thái hai chiều.
  - Hỗ trợ thao tác vuốt để Xóa với `Dismissible` (hiện nền đỏ và icon thùng rác).

- **Checkout & Orders (Thanh toán & Lịch sử Đơn):**
  - Lịch sử Đơn: Sử dụng thẻ `DefaultTabController` vuốt ngang (TabBar: Chờ xác nhận, Đang giao, Đã giao, Đã hủy).

### Code Quality & Workflow Rules

- Việc commit/làm việc theo nhóm yêu cầu chia nhánh repo theo từng thành viên. Code được tập hợp (Merges) thành 1 video/bài báo cáo.

### Critical Don't-Miss Rules

- 🚫 **CẤM DÙNG:** `Navigator.push` để truyền dữ liệu Giỏ hàng nguyên cục (Cart List) qua lại giữa các tham số màn hình. Phải sử dụng giải pháp State Management để Provider/GetX bao bọc lấy trạng thái giỏ hàng. Lỗi này bị trừ điểm nặng!
- ⚠️ Nút Checkbox trong Giỏ hàng: Nút tick "Chọn tất cả" phải đồng bộ hai chiều (Tick All tự động sáng lên nếu chọn tay hết, và sẽ tắt tự động ngay lập tức nếu bỏ chọn một mục).
- ⚠️ **Data Precision:** Giá tiền phải luôn **format đúng định dạng tiền tệ** (`150.000đ` hoặc `$15.00`) ở tất cả các nơi xuất hiện. Đừng để mức giá int hoặc float bị thô.