# Retrospective Report: Epic 3 - Quản lý Giỏ hàng Thông minh

**Dự án:** TH4
**Người thực hiện:** Nguyên
**Ngày thực hiện:** 2026-03-15
**Epic:** 3

## 📊 Tổng kết Epic
Epic 3 đã hoàn thành mục tiêu xây dựng một hệ thống quản lý giỏ hàng tập trung, đảm bảo tính nhất quán của dữ liệu và phản hồi người dùng mượt mà. Tất cả các tính năng từ Badge, Checkbox sync, Real-time calculation đến Data Persistence đều được triển khai thành công trong một Story duy nhất (3.1).

## ✅ Điểm tốt (What went well)
- **Kiến trúc Single Source of Truth:** Sử dụng `Provider` giúp loại bỏ hoàn toàn việc truyền dữ liệu thủ công, giảm thiểu lỗi đồng bộ.
- **Tốc độ phản hồi:** Tính toán tổng tiền và cập nhật số lượng diễn ra tức thì (< 100ms), đáp ứng yêu cầu NFR.
- **Trải nghiệm người dùng:** Thao tác `Dismissible` và các Dialog xác nhận được triển khai chỉn chu, tăng độ an toàn cho dữ liệu.
- **Cấu trúc code:** Tách biệt rõ ràng giữa logic nghiệp vụ (`CartProvider`), lưu trữ (`StorageService`) và định dạng (`CurrencyUtils`).

## ⚠️ Khó khăn & Bài học (Challenges & Lessons Learned)
- **Gộp Story:** Story 3.1 khá lớn, bao gồm cả UI và logic Persistence. Ở các Epic sau (như Epic 4), nên cân nhắc chia tách các story nhỏ hơn (ví dụ: tách phần UI và phần Persistence) để dễ kiểm soát và review.
- **Logic Checkbox:** Việc đồng bộ 2 chiều (Tick All <-> Individual) đòi hỏi sự cẩn trọng cao để tránh vòng lặp thông báo (notifiers). Bài học là nên kiểm soát biến `isSelectAllAction` để phân biệt nguồn gốc thay đổi.

## 🚀 Hành động cho Epic 4 (Action Items)
1. **Phân rã Epic 4:** Chạy quy trình sprint-planning để chia nhỏ Epic 4 thành ít nhất 2 stories: (1) UI TabBar & Order Screens, (2) Persistence & Order Logic.
2. **Tái sử dụng Service:** Tiếp tục sử dụng `StorageService` đã xây dựng bên Epic 3 để quản lý danh sách đơn hàng.
3. **Widget Refactoring:** Trích xuất các component dùng chung (ví dụ: Product Card thu nhỏ) từ Cart sang Widgets để dùng lại trong màn hình đơn mua.

---
*Báo cáo được tạo tự động bởi BMAD Retrospective Agent.*
