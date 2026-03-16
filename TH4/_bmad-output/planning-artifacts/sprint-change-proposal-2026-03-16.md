# Sprint Change Proposal - TH4

**Date:** 2026-03-16
**Author:** Gemini CLI
**Issue Trigger:** Functional failures in Search, Home interactions, and Cart integration.

## 1. Issue Summary

Trong quá trình kiểm thử, chúng tôi phát hiện 4 nhóm vấn đề nghiêm trọng làm gián đoạn luồng trải nghiệm người dùng (User Journeys) đã định nghĩa trong PRD:
1.  **Thanh tìm kiếm (Home):** Chỉ là giao diện tĩnh, chưa kết nối logic tìm kiếm với `ProductProvider`.
2.  **Tương tác Trang chủ:** Banner và các nút Danh mục (Categories) không phản hồi khi nhấn.
3.  **Lỗi logic Giỏ hàng (Detail):** Nút "Xác nhận" trong BottomSheet chỉ hiển thị SnackBar mà không thực sự gọi hàm `addItem` của `CartProvider`.
4.  **Tắc nghẽn chức năng:** Do không thể thêm hàng vào giỏ, toàn bộ logic tính tiền và quản lý giỏ hàng (Epic 3) hiện chưa thể kiểm tra thực tế.

## 2. Impact Analysis

| Artifact | Impact Description |
| :--- | :--- |
| **PRD** | MVP core flows (Search, Buy, Add to Cart) bị hỏng, ảnh hưởng trực tiếp đến User Journey 1 & 2. |
| **Epics** | **Epic 1** (Discovery) và **Epic 2** (Engagement) bị đánh dấu "Done" sai thực tế. **Epic 3** bị chặn (blocked). |
| **Architecture** | Không có thay đổi lớn về kiến trúc, nhưng cần bổ sung logic Search trong `ProductProvider`. |
| **Stories** | Story 1.3, 2.2, 3.1 cần được mở lại để sửa lỗi logic. |

## 3. Recommended Approach: Direct Adjustment (Điều chỉnh trực tiếp)

Chúng tôi sẽ không thực hiện Rollback mà sẽ tiến hành sửa lỗi trực tiếp trên các file hiện có để đảm bảo tiến độ.

**Các bước thực hiện:**
1.  **Bổ sung logic Search:** Cập nhật `ProductProvider` để hỗ trợ lọc sản phẩm theo tên.
2.  **Kích hoạt tương tác Home:** Thêm `onTap` cho Banner và Category Grid (lọc theo danh mục).
3.  **Kết nối Cart Logic:** Sửa `ProductAttributesBottomSheet` để gọi `CartProvider.addItem` khi nhấn "Xác nhận".
4.  **Phân loại luồng Mua hàng:** Cập nhật `ProductDetailScreen` để "Mua ngay" sẽ điều hướng thẳng vào Giỏ hàng sau khi thêm.

## 4. Detailed Change Proposals

### Story 1.3: Home Search & Interaction
- **OLD:** `TextField` tĩnh.
- **NEW:** `TextField` gọi `productProvider.searchProducts(query)` khi `onChanged`. Thêm logic lọc danh mục khi nhấn vào các icon.

### Story 2.2: Product Detail Actions
- **OLD:** BottomSheet chỉ hiện SnackBar.
- **NEW:** 
  - Nút "Xác nhận" gọi `cartProvider.addItem(...)`.
  - Phân biệt giữa `actionType == 'add'` (hiện SnackBar) và `actionType == 'buy'` (điều hướng sang Cart).

### Story 3.1: Cart Verification
- Sau khi sửa lỗi thêm hàng, tiến hành kiểm tra logic `Select All` và `Total Price` real-time.

## 5. Implementation Handoff
- **Role:** Development Team (Gemini CLI).
- **Responsibility:** Thực hiện fix lỗi logic trên 4 file: `product_provider.dart`, `home_screen.dart`, `product_detail_screen.dart`, `product_attributes_bottom_sheet.dart`.
- **Success Criteria:** 
  - Tìm kiếm trả về kết quả đúng.
  - Nhấn "Xác nhận" -> Badge giỏ hàng nhảy số -> Vào giỏ hàng thấy đúng sản phẩm + size + màu.

---
**Bạn có phê duyệt đề xuất thay đổi này không? (yes/no/revise)** yes
