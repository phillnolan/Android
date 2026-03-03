# task

Một dự án Flutter mới.

## Giới thiệu

Đây là một ứng dụng di động được phát triển bằng Flutter, cho phép người dùng quản lý các công việc của mình một cách hiệu quả. Ứng dụng cung cấp chức năng tạo, phân loại, chỉnh sửa, đánh dấu hoàn thành và xóa các công việc. Người dùng có thể tạo nhiều danh mục khác nhau để sắp xếp công việc một cách hợp lý và theo dõi trạng thái hoàn thành cũng như thời hạn của từng công việc.

## Cách chạy dự án

Để chạy dự án này trên môi trường phát triển cục bộ của bạn, hãy làm theo các bước sau:

### Yêu cầu

*   [Flutter SDK](https://flutter.dev/docs/get-started/install) đã được cài đặt.
*   Một IDE (ví dụ: VS Code, Android Studio) với plugin Flutter đã được cài đặt.
*   Thiết bị Android/iOS hoặc trình giả lập/mô phỏng đã được cấu hình.

### Cài đặt và chạy

1.  **Clone repository:**
    ```bash
    git clone <URL_repository_của_bạn>
    cd task
    ```
    *(Thay `<URL_repository_của_bạn>` bằng URL thực tế của repository nếu có.)*

2.  **Cài đặt các dependency:**
    ```bash
    flutter pub get
    ```

3.  **Chạy ứng dụng:**
    *   Đảm bảo rằng bạn có một thiết bị hoặc trình giả lập đang chạy.
    *   Chạy ứng dụng từ terminal:
        ```bash
        flutter run
        ```
    *   Hoặc chạy từ IDE của bạn (nhấn F5 trong VS Code hoặc nút Run trong Android Studio).

---

## Bắt đầu

Dự án này là điểm khởi đầu cho một ứng dụng Flutter.

Một vài tài nguyên để giúp bạn bắt đầu nếu đây là dự án Flutter đầu tiên của bạn:

-   [Tìm hiểu Flutter](https://docs.flutter.dev/get-started/learn-flutter)
-   [Viết ứng dụng Flutter đầu tiên của bạn](https://docs.flutter.dev/get-started/codelab)
-   [Tài nguyên học Flutter](https://docs.flutter.dev/reference/learning-resources)

Để được trợ giúp bắt đầu phát triển Flutter, hãy xem
[tài liệu trực tuyến](https://docs.flutter.dev/), cung cấp các hướng dẫn,
ví dụ, hướng dẫn về phát triển di động và tài liệu tham khảo API đầy đủ.

## Tổng quan mã nguồn

Dự án Flutter này triển khai một ứng dụng danh sách công việc đơn giản với tính năng phân loại.

### Các thành phần cốt lõi:

*   **`lib/main.dart`**:
    *   **Điểm khởi chạy ứng dụng**: Khởi tạo và chạy ứng dụng Flutter.
    *   **Cấu hình giao diện (Theme)**: Thiết lập giao diện tổng thể cho ứng dụng, bao gồm màu sắc cho `AppBar` và `FloatingActionButton`.
    *   **Quản lý trạng thái (Danh mục và Công việc)**: Quản lý các danh sách trung tâm của đối tượng `Category` và `Task`.
    *   **Các thao tác CRUD**: Cung cấp các phương thức (`_addTask`, `_updateTask`, `_toggleTask`, `_deleteTask`, `_addCategory`, `_deleteCategory`) để tạo, đọc, cập nhật và xóa công việc và danh mục.
    *   **Điều hướng**: Xử lý điều hướng giữa `CategoryGridScreen` (màn hình chính hiển thị các danh mục) và các thể hiện riêng lẻ của `TaskListScreen`.
    *   **Hộp thoại**: Triển khai các hộp thoại để thêm danh mục mới và xác nhận xóa danh mục.
*   **`lib/task_list_screen.dart`**:
    *   **Hiển thị danh sách công việc**: Hiển thị tất cả các công việc thuộc một `Category` cụ thể.
    *   **Lọc công việc**: Cho phép người dùng lọc công việc theo "Tất cả", "Đã hoàn thành" hoặc "Chưa hoàn thành".
    *   **Giao diện quản lý công việc**: Cung cấp giao diện người dùng và logic để thêm công việc mới, chỉnh sửa công việc hiện có và xóa công việc trong danh mục đã chọn.
    *   **Bộ chọn ngày/giờ**: Tích hợp `showDatePicker` và `showTimePicker` để đặt ngày đến hạn cho công việc.
*   **`lib/models/category.dart`**:
    *   **Mô hình dữ liệu**: Định nghĩa cấu trúc cho một đối tượng `Category` với các thuộc tính `id` (String) và `name` (String).
*   **`lib/models/task.dart`**:
    *   **Mô hình dữ liệu**: Định nghĩa cấu trúc cho một đối tượng `Task`, bao gồm `id` (String), `title` (String), `categoryId` (String), `isCompleted` (bool, mặc định `false`), `timestamp` (DateTime tạo), và `dueDate` (DateTime, tùy chọn).
*   **`lib/widgets/todo_item_widget.dart`**:
    *   **Thành phần UI có thể tái sử dụng**: Hiển thị một mục công việc duy nhất trong danh sách.
    *   **Chi tiết công việc**: Hiển thị tiêu đề công việc, ngày tạo, ngày đến hạn và chỉ báo trực quan về trạng thái hoàn thành.
    *   **Theo dõi thời gian**: Tính toán và hiển thị thời gian còn lại cho đến ngày đến hạn hoặc cho biết công việc đã quá hạn.
    *   **Các yếu tố tương tác**: Bao gồm một hộp kiểm để chuyển đổi trạng thái hoàn thành công việc và các `IconButton` để chỉnh sửa và xóa công việc.

## Các ý tưởng phát triển

*   **Lưu trữ dữ liệu**: Hiện tại dữ liệu được lưu trong bộ nhớ. Cân nhắc tích hợp cơ sở dữ liệu cục bộ (như SQLite với `sqflite` hoặc Hive) hoặc lưu trữ đám mây (như Firebase Firestore) để dữ liệu tồn tại lâu dài.
*   **Thông báo**: Thêm chức năng thông báo đẩy để nhắc nhở người dùng về các công việc sắp đến hạn hoặc quá hạn.
*   **Phân loại nâng cao**: Cho phép người dùng tùy chỉnh màu sắc, biểu tượng cho từng danh mục.
*   **Sắp xếp và tìm kiếm**: Cải thiện khả năng sắp xếp công việc (theo ngày đến hạn, mức độ ưu tiên) và thêm chức năng tìm kiếm công việc.
*   **Tính năng ưu tiên**: Thêm trường mức độ ưu tiên cho công việc (cao, trung bình, thấp).
*   **Chia sẻ công việc**: Cho phép chia sẻ danh sách công việc hoặc từng công việc với người dùng khác (yêu cầu backend).
*   **Giao diện người dùng (UI/UX)**: Cải thiện giao diện người dùng với các hiệu ứng động, chuyển đổi mượt mà hơn, hoặc tùy chỉnh giao diện theo sở thích người dùng.
*   **Chế độ tối (Dark Mode)**: Triển khai chế độ tối cho ứng dụng.
*   **Hỗ trợ đa ngôn ngữ**: Cho phép ứng dụng hiển thị bằng nhiều ngôn ngữ khác nhau.
