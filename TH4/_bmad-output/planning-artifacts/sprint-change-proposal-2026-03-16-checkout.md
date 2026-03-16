# Sprint Change Proposal - TH4 - Checkout Feature

**Date:** 2026-03-16
**Author:** Gemini CLI
**Issue Trigger:** Missing "Checkout" screen identified in PRD MVP but absent from Epics/Stories.

## 1. Issue Summary

Trong quá trình rà soát lại PRD và tiến độ dự án, chúng tôi phát hiện một khoảng trống (gap) trong luồng mua sắm: Màn hình **Checkout** (Thanh toán/Xác nhận đơn hàng) chưa được định nghĩa trong danh sách Epics và Stories, mặc dù nó là một phần của MVP theo PRD. Hiện tại app mới chỉ dừng lại ở Giỏ hàng và xem Lịch sử đơn hàng, thiếu bước đệm để người dùng nhập thông tin giao hàng và xác nhận đặt hàng.

## 2. Impact Analysis

| Artifact | Impact Description |
| :--- | :--- |
| **PRD** | Hoàn thiện 100% MVP scope đã cam kết trong PRD. |
| **Epics** | Cần bổ sung **Epic 5** để quản lý luồng Thanh toán. |
| **Architecture** | Bổ sung `CheckoutScreen` và logic `clearCart()` sau khi đặt hàng thành công. |
| **Stories** | Tạo mới **Story 5.1** để thực hiện màn hình Checkout. |

## 3. Recommended Approach: Direct Adjustment (Điều chỉnh trực tiếp)

Thêm mới Epic 5 và Story 5.1 vào kế hoạch hiện tại. Đây là phương án minh bạch nhất để theo dõi tiến độ hoàn thiện MVP.

## 4. Detailed Change Proposals

### New Epic: Epic 5 - Thanh toán & Hoàn tất (Checkout & Finalization)
Người dùng có thể nhập thông tin nhận hàng, kiểm tra lại đơn hàng lần cuối và tiến hành đặt hàng để hoàn tất luồng mua sắm.
**FRs covered:** FR9 (partial), New Requirement (Checkout flow).

### New Story: Story 5.1 - Xây dựng màn hình Checkout và logic Đặt hàng
**As a** người dùng,
**I want** nhập thông tin giao hàng và xác nhận đơn hàng,
**So that** tôi có thể hoàn tất việc mua sắm và chuyển sang trạng thái chờ giao hàng.

**Acceptance Criteria:**
- **Given** người dùng nhấn nút "Thanh toán" từ màn hình Giỏ hàng.
- **When** màn hình Checkout hiển thị.
- **Then** người dùng có thể nhập các thông tin: Họ tên, Số điện thoại, Địa chỉ.
- **And** hiển thị tóm tắt đơn hàng (Tổng số lượng, Tổng tiền cuối cùng).
- **And** khi nhấn "Xác nhận đặt hàng", hệ thống phải:
    1. Gọi hàm xóa sạch giỏ hàng trong `CartProvider`.
    2. Thông báo đặt hàng thành công.
    3. Điều hướng người dùng về màn hình Home hoặc Lịch sử đơn hàng.

## 5. Implementation Handoff
- **Role:** SM Agent (để cập nhật `epics.md` và `sprint-status.yaml`).
- **Responsibility:** 
    - Cập nhật `epics.md` với Epic 5.
    - Cập nhật `sprint-status.yaml` với story 5-1 ở trạng thái `backlog`.
    - Chạy `create-story` cho 5-1.
- **Success Criteria:** Story 5.1 được khởi tạo với đầy đủ context để Dev agent thực hiện.
