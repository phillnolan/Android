---
stepsCompleted: ['step-01-init', 'step-02-discovery', 'step-02b-vision', 'step-02c-executive-summary', 'step-03-success', 'step-04-journeys']
inputDocuments: ['D:/64HTTT4/Android/TH/TH4/th4.pdf', 'D:/64HTTT4/Android/TH/TH4/_bmad-output/project-context.md']
documentCounts:
  briefCount: 0
  researchCount: 0
  brainstormingCount: 0
  projectDocsCount: 1
classification:
  projectType: 'Mobile Application (Flutter)'
  domain: 'E-commerce'
  complexity: 'Medium'
  projectContext: 'brownfield'
workflowType: 'prd'
---

# Product Requirements Document - TH4

**Author:** Nguyên
**Date:** 2026-03-15

## Executive Summary

Ứng dụng Mini E-commerce (TH4) là một giải pháp thương mại điện tử di động tập trung vào trải nghiệm mua sắm mượt mà và quản lý trạng thái dữ liệu chính xác. Sản phẩm cung cấp một luồng mua sắm khép kín hoàn chỉnh, tập trung vào việc giải quyết bài toán đồng bộ dữ liệu liên màn hình và tối ưu hóa các điểm chạm tương tác người dùng. Vấn đề cốt lõi được giải quyết là tính nhất quán của trạng thái giỏ hàng và khả năng phản hồi UI tức thì (Real-time) trong một kiến trúc ứng dụng chuẩn mực.

### What Makes This Special

Sản phẩm tạo sự khác biệt thông qua việc kết hợp giữa hiệu ứng thị giác hiện đại và logic xử lý dữ liệu chặt chẽ:
- **Tối ưu hóa luồng mua hàng:** Sử dụng **BottomSheet** tại màn hình chi tiết để xử lý các thuộc tính sản phẩm (Size, Màu sắc, Số lượng), giảm thiểu việc chuyển hướng màn hình và giữ chân người dùng trong ngữ cảnh mua sắm.
- **Phản hồi Real-time tuyệt đối:** Badge giỏ hàng và tổng tiền thanh toán được cập nhật ngay lập tức với hiệu ứng nảy số mà không cần tải lại trang, tăng độ tin cậy và minh bạch của dữ liệu.
- **Trải nghiệm UX cao cấp:** Áp dụng **SliverAppBar** với Search Bar dính (sticky), **Hero Animation** mượt mà khi chuyển cảnh và **Infinite Scroll** cho danh sách sản phẩm dài vô tận.
- **Kỷ luật kiến trúc (State Management):** Đảm bảo tính mở rộng bằng cách sử dụng Provider/GetX, loại bỏ hoàn toàn việc truyền dữ liệu thủ công qua Navigator, giúp hệ thống ổn định và dễ bảo trì.

## Project Classification

- **Project Type:** Mobile Application (Flutter)
- **Domain:** E-commerce (Bán lẻ trực tuyến)
- **Complexity:** Medium (Yêu cầu quản lý trạng thái phức tạp và persistence dữ liệu)
- **Project Context:** Brownfield (Tuân thủ quy tắc và kiến trúc đã định nghĩa sẵn)

## Success Criteria

### User Success
*   **Trải nghiệm không gián đoạn:** Người dùng có thể thêm hàng vào giỏ từ màn hình Chi tiết thông qua BottomSheet mà không bị chuyển màn hình, cảm nhận được sự phản hồi tức thì qua SnackBar được thiết kế lại chuyên nghiệp và Badge giỏ hàng.
*   **Điều hướng mượt mà:** Sử dụng Hero Animation, SliverAppBar và hiệu ứng chuyển cảnh mượt mà giữa các danh mục sản phẩm tạo cảm giác ứng dụng cao cấp.
*   **Phản hồi xác thực:** Nhận được thông báo thành công rõ ràng sau khi đặt hàng (Success Overlay/Screen) giúp tăng sự tin cậy.

### Business Success (Mục tiêu học thuật)
*   **Đáp ứng 100% yêu cầu bài tập:** Hoàn thiện đầy đủ 4 màn hình cốt lõi và các logic nghiệp vụ.
*   **Điểm số tối đa:** Đạt điểm cộng nhờ việc triển khai Data Persistence, Infinite Scrolling và các hiệu ứng Animation/Polish chuyên nghiệp.
*   **Nộp bài đúng hạn:** Hoàn thành trước buổi học TH5 theo yêu cầu của giảng viên.

### Technical Success
*   **Kiến trúc sạch:** Tuân thủ tuyệt đối mô hình MVC/MVVM với cấu trúc thư mục rõ ràng.
*   **Quản lý trạng thái chuyên nghiệp:** Không sử dụng Navigator.push để truyền List giỏ hàng; toàn bộ trạng thái giỏ hàng phải được quản lý tập trung qua Provider/GetX.
*   **Hiệu suất:** Infinite Scroll (Pagination) hoạt động mượt mà, không giật lag khi tải thêm dữ liệu từ API.

### Measurable Outcomes
*   100% logic "Chọn tất cả" và "Hủy chọn" đồng bộ hai chiều chính xác.
*   Giỏ hàng được bảo toàn dữ liệu sau khi tắt ứng dụng và mở lại (Data Persistence).
*   Thời gian phản hồi cập nhật tổng tiền trong giỏ hàng < 100ms.

## Product Scope

### MVP - Minimum Viable Product
*   4 màn hình chính: Home, Detail, Cart, Checkout/Orders.
*   Tích hợp FakeStore API lấy dữ liệu thực tế.
*   State Management (Provider/GetX) cho Giỏ hàng.
*   Logic tính tiền động và quản lý Checkbox trong giỏ.

### Growth Features (Post-MVP)
*   Lưu trữ giỏ hàng Offline (SharedPreferences).
*   Xử lý Infinite Scroll & Pull-to-refresh.
*   Hero Animation & Custom UI (SliverAppBar).

### Vision (Future)
*   Tích hợp Firebase lưu trữ đơn hàng thực tế.
*   Hệ thống thông báo (Notification) khi có khuyến mãi.
*   Theo dõi trạng thái giao hàng Real-time.

## User Journeys

### 1. Minh - Người mua sắm bận rộn (Luồng Happy Path)
*   **Bối cảnh:** Minh là một nhân viên văn phòng, anh muốn mua nhanh một món đồ điện tử trong giờ nghỉ giải lao.
*   **Hành trình:** 
    *   **Mở đầu:** Minh mở app, thấy ngay Banner khuyến mãi đang tự động chạy mượt mà. Anh dùng thanh Search dính ở đỉnh đầu để tìm "Laptop".
    *   **Diễn biến:** Anh cuộn danh mục thấy hiệu ứng đổi màu AppBar rất chuyên nghiệp. Anh chọn một sản phẩm, tấm ảnh "bay" mượt mà (Hero Animation) sang màn hình chi tiết.
    *   **Cao trào:** Anh bấm "Thêm vào giỏ", một BottomSheet đẩy lên từ đáy giúp anh chọn màu Xám và RAM 16GB chỉ trong 2 giây. Một thông báo hiện lên ngắn gọn "Thêm thành công" và anh thấy con số trên biểu tượng Giỏ hàng nhảy lên ngay lập tức.
    *   **Kết thúc:** Minh cảm thấy app cực kỳ "nhạy" và phản hồi tốt, anh yên tâm quay lại làm việc.
*   **Yêu cầu lộ diện:** SliverAppBar, Search logic, Hero Animation, BottomSheet, SnackBar & Cart Badge sync.

### 2. Linh - Sinh viên săn sale (Luồng Quản lý trạng thái phức tạp)
*   **Bối cảnh:** Linh đang chọn nhiều món đồ thời trang và muốn so sánh tổng tiền để không vượt quá ngân sách.
*   **Hành trình:**
    *   **Mở đầu:** Linh lướt mục "Gợi ý hôm nay" với danh sách dài vô tận (Infinite Scroll). Cô thêm 5-6 món đồ khác nhau vào giỏ.
    *   **Diễn biến:** Trong giỏ hàng, Linh thử bấm "Chọn tất cả" để xem tổng số tiền lớn, sau đó cô bỏ tick một chiếc váy đắt tiền. Ngay lập tức, con số tổng thanh toán ở dưới đáy màn hình giảm xuống mà không có độ trễ.
    *   **Cao trào:** Cô thấy một món đồ bị nhầm, cô vuốt mạnh sang trái (Dismissible), một icon thùng rác hiện ra trên nền đỏ. App hỏi "Bạn có muốn xóa không?", cô chọn "Có".
    *   **Kết thúc:** Linh kiểm soát được chi tiêu nhờ tính toán Real-time chính xác trước khi bấm "Đặt hàng".
*   **Yêu cầu lộ diện:** Infinite Scroll, Real-time Price calculation, "Select All" two-way logic, Dismissible delete with confirmation.

### 3. Hoàng - Khách hàng quay lại (Luồng Persistence & History)
*   **Bối cảnh:** Hoàng đã đặt hàng hôm qua và muốn kiểm tra trạng thái đơn hàng của mình.
*   **Hành trình:**
    *   **Mở đầu:** Hoàng mở lại app sau khi đã tắt hẳn từ tối qua. Anh vào Giỏ hàng và thấy món đồ định mua thêm vẫn còn nằm đó (Persistence).
    *   **Diễn biến:** Anh chuyển sang mục "Đơn mua". Anh vuốt ngang qua các Tab: Chờ xác nhận, Đang giao, Đã giao một cách dễ dàng nhờ TabBar mượt mà.
    *   **Kết thúc:** Hoàng thấy đơn hàng của mình đang ở trạng thái "Đang giao" và cảm thấy hài lòng vì dữ liệu được lưu trữ ổn định.
*   **Yêu cầu lộ diện:** Data Persistence (SharedPreferences/Firebase), DefaultTabController cho Order History.

### Journey Requirements Summary

*   **Giao diện nâng cao:** SliverAppBar, Hero Animation, Carousel Slider, Custom BottomSheet.
*   **Logic cốt lõi:** Quản lý trạng thái Giỏ hàng tập trung, Real-time calculation, Checkbox sync 2 chiều.
*   **Xử lý dữ liệu:** Infinite Scrolling, Persistence (Offline data), TabBar navigation.

## Domain-Specific Requirements

### Compliance & Regulatory (Tuân thủ & Quy định)
- **Chuẩn định dạng tiền tệ:** Giá sản phẩm phải được format chính xác theo vùng miền (Ví dụ: `150.000đ` hoặc `$15.00`). Tuyệt đối không hiển thị con số thô (int/double) trên UI.
- **Quy tắc tính toán đơn hàng:** Tổng tiền thanh toán phải là giá trị tính toán động dựa trên các sản phẩm đã được tick chọn (checked). Việc bỏ tick một sản phẩm phải kích hoạt tính toán lại tổng tiền ngay lập tức (Real-time).

### Technical Constraints (Ràng buộc kỹ thuật)
- **Kiến trúc dữ liệu đồng bộ:** Hệ thống phải đảm bảo trạng thái giỏ hàng (Cart State) được quản lý tập trung (Single Source of Truth). Cấm các phương pháp truyền dữ liệu thủ công giữa các màn hình để tránh sai lệch dữ liệu.
- **Trải nghiệm mạng:** Khi tải danh sách sản phẩm từ **FakeStore API**, phải có hiệu ứng loading (Shimmer hoặc mờ) để người dùng không thấy màn hình trắng.
- **Dung lượng video báo cáo:** Theo quy định nộp bài, video demo trên YouTube phải có dung lượng `<= 100mb` và định dạng `.mp4`.

### Integration Requirements (Yêu cầu tích hợp)
- **FakeStore API:** Tích hợp để lấy danh sách sản phẩm thực tế, phân loại danh mục và thông tin chi tiết.
- **Local Persistence:** Sử dụng `SharedPreferences` hoặc `Firebase` để duy trì giỏ hàng ngay cả khi ứng dụng bị tắt hoàn toàn.
- **Firebase/Firebase Auth (Tùy chọn):** Nếu triển khai để lấy điểm cộng, phải đảm bảo luồng Authentication không gây gián đoạn luồng xem sản phẩm (Guest mode).

### Risk Mitigations (Giảm thiểu rủi ro)
- **Rủi ro mất dữ liệu:** Xử lý ngoại lệ khi giỏ hàng trống hoặc lỗi kết nối API. Hiển thị UI thông báo thân thiện (Empty State) thay vì để ứng dụng bị crash.
- **Rủi ro logic Checkbox:** Logic "Chọn tất cả" phải đồng bộ 2 chiều (Tick hết item -> Chọn tất cả tự sáng; Bỏ tick 1 item -> Chọn tất cả tự tắt) để tránh người dùng đặt nhầm hàng.
- **Rủi ro xóa nhầm:** Thao tác vuốt để xóa (`Dismissible`) phải kèm theo hộp thoại xác nhận để tránh người dùng lỡ tay mất dữ liệu giỏ hàng.
