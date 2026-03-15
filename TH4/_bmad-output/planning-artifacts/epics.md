---
stepsCompleted: ['step-01-validate-prerequisites', 'step-02-design-epics']
inputDocuments: ['_bmad-output/planning-artifacts/prd.md', '_bmad-output/planning-artifacts/architecture.md']
---

# TH4 - Epic Breakdown

## Overview

This document provides the complete epic and story breakdown for TH4, decomposing the requirements from the PRD, UX Design if it exists, and Architecture requirements into implementable stories.

## Requirements Inventory

### Functional Requirements

FR1: Màn hình Home với SliverAppBar sticky, Search bar, Carousel banner và GridView sản phẩm.
FR2: Xử lý Infinite Scrolling và Pull-to-refresh trên danh sách sản phẩm.
FR3: Màn hình Chi tiết với Hero Animation khi chuyển ảnh sản phẩm.
FR4: Sử dụng BottomSheet tại màn hình Chi tiết để chọn Size, Màu sắc, Số lượng.
FR5: Cập nhật số lượng trên Badge giỏ hàng Real-time.
FR6: Màn hình Giỏ hàng với logic Checkbox đồng bộ 2 chiều (Chọn tất cả <-> Từng item).
FR7: Tính toán tổng tiền thanh toán Real-time trong giỏ hàng.
FR8: Thao tác vuốt để xóa sản phẩm (Dismissible) kèm hộp thoại xác nhận.
FR9: Màn hình Đơn mua với TabBar phân loại trạng thái (Chờ xác nhận, Đang giao, Đã giao).
FR10: Tích hợp FakeStore API lấy dữ liệu thực tế.
FR11: Lưu trữ giỏ hàng Offline (Persistence) để bảo toàn dữ liệu khi tắt app.

### NonFunctional Requirements

NFR1: Tốc độ phản hồi UI khi cập nhật giỏ hàng/tính tiền < 100ms.
NFR2: Định dạng tiền tệ chuẩn `###.###đ` (Sử dụng `intl`).
NFR3: Quản lý trạng thái tập trung (Single Source of Truth) qua Provider.
NFR4: Hiển thị hiệu ứng Shimmer/Loading khi tải dữ liệu từ API.
NFR5: Tuân thủ cấu trúc thư mục quy định (`/lib/providers`, `/lib/models`,...).

### Additional Requirements

- **Starter Template**: Standard Flutter SDK (Version 3.41).
- **Data Modeling**: Sử dụng Dart Patterns (Sealed Classes) để quản lý trạng thái API.
- **Project Structure**: Tuân thủ nghiêm ngặt cấu trúc thư mục: `/lib/models`, `/lib/screens`, `/lib/widgets`, `/lib/services`, `/lib/providers`.
- **Navigation**: Navigator 2.0 với Named Routes.

### UX Design Requirements

UX-DR1: Hero Animation chuyển cảnh mượt mà giữa màn hình Home và Chi tiết.
UX-DR2: Sticky Search Bar tại Home tích hợp trong SliverAppBar.
UX-DR3: Thao tác Dismissible trong giỏ hàng với nền đỏ và icon thùng rác, kèm Dialog xác nhận.
UX-DR4: BottomSheet chọn thuộc tính sản phẩm không làm gián đoạn luồng mua sắm.

### FR Coverage Map

FR1 (Home UI): Epic 1
FR2 (Infinite Scroll): Epic 1
FR3 (Hero Detail): Epic 2
FR4 (BottomSheet Selection): Epic 2
FR5 (Badge Sync): Epic 3
FR6 (Checkbox Sync): Epic 3
FR7 (Real-time Calculation): Epic 3
FR8 (Dismissible Delete): Epic 3
FR9 (Order History Tabs): Epic 4
FR11 (Data Persistence): Epic 4
FR10 (FakeStore API): Epic 1

## Epic List

## Epic 1: Khởi tạo & Khám phá sản phẩm (Project Foundation & Discovery)
Người dùng có thể mở ứng dụng, xem danh sách sản phẩm lấy từ API thực tế với trải nghiệm mượt mà (cuộn trang vô hạn, tìm kiếm).
**FRs covered:** FR1, FR2, FR10, NFR4, NFR5, UX-DR2.

### Story 1.1: Khởi tạo Project Flutter và Cấu trúc thư mục chuẩn
As a developer,
I want khởi tạo dự án Flutter với cấu trúc thư mục MVC/MVVM đã định nghĩa,
So that tôi có một nền tảng vững chắc và tuân thủ kỷ luật kiến trúc của dự án.

**Acceptance Criteria:**
**Given** môi trường phát triển Flutter đã sẵn sàng
**When** chạy lệnh khởi tạo project và tạo các thư mục: `/lib/models`, `/lib/screens`, `/lib/widgets`, `/lib/services`, `/lib/providers`
**Then** cấu trúc thư mục phải khớp 100% với tài liệu Architecture
**And** tệp `pubspec.yaml` phải bao gồm các thư viện: `provider`, `intl`, `http` hoặc `dio`

### Story 1.2: Tích hợp FakeStore API và Xây dựng Data Models
As a developer,
I want xây dựng service gọi API và chuyển đổi dữ liệu thành các Product Model,
So that ứng dụng có dữ liệu thực tế để hiển thị.

**Acceptance Criteria:**
**Given** FakeStore API hoạt động bình thường
**When** Service thực hiện lệnh GET đến endpoint `/products`
**Then** dữ liệu JSON phải được parse thành `ProductModel` sử dụng chuẩn Dart Patterns
**And** xử lý được 3 trạng thái: Loading, Success, và Error

### Story 1.3: Màn hình Home với SliverAppBar và Search Bar "Sticky"
As a người dùng,
I want thấy một thanh tìm kiếm luôn hiển thị ở đầu trang và Carousel banner bắt mắt,
So that tôi có thể dễ dàng tìm kiếm sản phẩm và xem các chương trình khuyến mãi.

**Acceptance Criteria:**
**Given** người dùng đang ở màn hình Home
**When** người dùng cuộn trang xuống dưới
**Then** `SliverAppBar` phải thu nhỏ nhưng `SearchBar` vẫn được giữ lại (Sticky) ở đỉnh màn hình
**And** Carousel banner phải tự động chạy mượt mài

### Story 1.4: Hiển thị Danh sách sản phẩm với Infinite Scroll
As a người dùng,
I want xem danh sách sản phẩm tải thêm liên tục khi cuộn xuống và có hiệu ứng loading,
So that tôi có thể khám phá hàng trăm sản phẩm mà không bị gián đoạn.

**Acceptance Criteria:**
**Given** danh sách sản phẩm có nhiều hơn 10 item
**When** người dùng cuộn đến cuối danh sách
**Then** ứng dụng phải tự động gọi API để tải trang tiếp theo
**And** hiển thị hiệu ứng `Shimmer` hoặc `CircularProgressIndicator` trong khi chờ dữ liệu
**And** hỗ trợ tính năng Pull-to-refresh để làm mới danh sách

### Epic 2: Trải nghiệm Chi tiết & Tương tác (Product Engagement & Details)
Người dùng có thể xem thông tin chi tiết sản phẩm với hiệu ứng Hero mượt mà và tùy chọn thuộc tính (size, màu) qua BottomSheet mà không bị gián đoạn luồng trải nghiệm.
**FRs covered:** FR3, FR4, UX-DR1, UX-DR4.

### Story 2.1: Chuyển cảnh sang màn hình Chi tiết với Hero Animation
As a người dùng,
I want tấm ảnh sản phẩm "bay" mượt mà từ danh sách Home sang trang Chi tiết khi tôi nhấn vào,
So that tôi cảm thấy ứng dụng cao cấp và không bị mất dấu món hàng mình vừa chọn.

**Acceptance Criteria:**
**Given** người dùng đang ở màn hình Home
**When** nhấn vào một thẻ sản phẩm bất kỳ
**Then** ứng dụng điều hướng sang màn hình Chi tiết
**And** ảnh sản phẩm phải thực hiện `Hero Animation` khớp chính xác giữa hai màn hình

### Story 2.2: Lựa chọn thuộc tính sản phẩm qua BottomSheet
As a người dùng,
I want chọn kích cỡ (Size), màu sắc và số lượng thông qua một bảng đẩy lên từ đáy màn hình thay vì chuyển sang trang mới,
So that tôi có thể tùy chỉnh nhanh chóng và quay lại xem thông tin sản phẩm dễ dàng.

**Acceptance Criteria:**
**Given** người dùng đang ở màn hình Chi tiết sản phẩm
**When** nhấn nút "Chọn phân loại" hoặc "Thêm vào giỏ"
**Then** một `BottomSheet` phải hiện lên hiển thị danh sách Size, Màu sắc và bộ chọn số lượng
**And** các lựa chọn phải được phản hồi ngay lập tức trên UI của BottomSheet
**And** có nút xác nhận để đóng bảng và lưu tạm lựa chọn

### Epic 3: Quản lý Giỏ hàng Thông minh (Cart Intelligence & Management)
Người dùng có toàn quyền kiểm soát giỏ hàng với logic tính toán tổng tiền Real-time, đồng bộ Checkbox 2 chiều và thao tác xóa nhanh chóng.
**FRs covered:** FR5, FR6, FR7, FR8, NFR1, NFR2, NFR3, UX-DR3.

### Story 3.1: Xây dựng Cart Provider và Giao diện Giỏ hàng cơ bản
As a người dùng,
I want xem danh sách các món hàng đã chọn và tổng tiền thanh toán được cập nhật ngay lập tức,
So that tôi có thể kiểm soát chi phí mua sắm của mình.

**Acceptance Criteria:**
- **Given** người dùng đã thêm ít nhất một sản phẩm vào giỏ
- **When** người dùng thay đổi số lượng (+) (-) hoặc tick/untick sản phẩm
- **Then** tổng số tiền thanh toán dưới đáy màn hình phải cập nhật tức thì (< 100ms)
- **And** nút "Chọn tất cả" phải đồng bộ trạng thái chính xác với các item đơn lẻ
- **And** thao tác vuốt để xóa (Dismissible) phải hiển thị hộp thoại xác nhận trước khi thực hiện

### Epic 4: Lưu trữ & Lịch sử Đơn hàng (Persistence & Purchase History)
Người dùng không bị mất dữ liệu giỏ hàng khi thoát ứng dụng và có thể theo dõi trạng thái các đơn hàng đã đặt qua giao diện Tab chuyên nghiệp.
**FRs covered:** FR9, FR11.

### Story 4.1: Lưu trữ Giỏ hàng Offline với SharedPreferences
As a khách hàng,
I want giỏ hàng của mình vẫn còn nguyên khi tôi mở lại ứng dụng sau khi đã thoát hẳn,
So that tôi không lãng phí thời gian chọn lại sản phẩm.

**Acceptance Criteria:**
- **Given** có sản phẩm trong giỏ hàng
- **When** ứng dụng bị đóng hoặc khởi động lại
- **Then** trạng thái giỏ hàng (sản phẩm, thuộc tính, số lượng) phải được khôi phục hoàn toàn
- **And** sử dụng SharedPreferences để thực hiện persistence dữ liệu local

### Story 4.2: Màn hình Lịch sử Đơn hàng với TabBar phân loại
As a khách hàng,
I want xem các đơn hàng của mình được phân loại rõ ràng theo trạng thái,
So that tôi dễ dàng theo dõi quá trình giao nhận.

**Acceptance Criteria:**
- **Given** người dùng vào mục "Đơn mua"
- **When** vuốt ngang màn hình hoặc nhấn vào các Tab
- **Then** ứng dụng phải chuyển đổi mượt mà giữa các Tab: Chờ xác nhận, Đang giao, Đã giao, Đã hủy
- **And** mỗi Tab hiển thị danh sách đơn hàng tương ứng với thiết kế thẻ (Card) chuẩn thương mại điện tử
