# Ứng dụng Quản Lý Sinh Viên & Todo

Một ứng dụng Flutter đơn giản để quản lý danh sách sinh viên và danh sách công việc (Todo).

## Chức năng chính

### 1. Quản lý sinh viên
- **Danh sách:** Xem danh sách sinh viên kèm ID và Điểm trung bình.
- **Thao tác:** Thêm mới, Sửa thông tin và Xóa sinh viên.
- **Tiện ích:** Tìm kiếm nhanh theo tên/ID và Sắp xếp theo tên hoặc điểm số.
- **Giao diện:** Hỗ trợ Chế độ Sáng/Tối (Light/Dark Mode).

### 2. Todo List (Quản lý công việc)
- **Lưu trữ bền vững:** Dữ liệu tự động lưu vào file JSON, không bị mất khi thoát ứng dụng.
- **Lịch hẹn & Deadline:** Đặt ngày giờ hẹn cho từng công việc. Tự động cảnh báo khi quá hạn.
- **Mức độ ưu tiên:** Thiết lập mức độ Cao, Trung bình, Thấp kèm biểu tượng màu sắc trực quan.
- **Thống kê tiến độ:** Thanh Progress Bar hiển thị % hoàn thành và báo cáo số lượng công việc.
- **Quản lý linh hoạt:** Hỗ trợ Sửa nội dung công việc, Lọc (Tất cả, Đã xong, Quá hạn...) và Sắp xếp thông minh.

## Kiến trúc ứng dụng

Ứng dụng phân tách rõ ràng giữa giao diện và logic:

- **`lib/main.dart`**: Cấu hình ứng dụng, điều hướng và quản lý Theme.
- **`lib/student_manager_page.dart`**: Giao diện và logic quản lý sinh viên.
- **`lib/todo_page.dart`**: Giao diện danh sách công việc và thống kê tiến độ.
- **`lib/student_model.dart` & `lib/todo_model.dart`**: Định nghĩa mô hình dữ liệu và lớp Repository xử lý lưu trữ file.

## Định hướng phát triển tiếp theo

- **Thông báo:** Tích hợp Local Notifications để nhắc nhở khi đến hạn công việc.
- **Xuất dữ liệu:** Tính năng xuất danh sách sinh viên ra file Excel hoặc PDF để in ấn/báo cáo.
- **Đồng bộ:** Kết nối Firebase để đồng bộ dữ liệu giữa các thiết bị.

## Hướng dẫn chạy dự án

1. **Cài đặt Flutter:** Đảm bảo bạn đã cài đặt Flutter SDK và thêm thư mục `bin` vào biến môi trường `PATH`.
2. **Kiểm tra môi trường:** Chạy lệnh sau trong terminal để kiểm tra:
   ```sh
   flutter doctor
   ```
3. **Chạy ứng dụng:**
   - Cách 1: Nhấn nút **Run** (biểu tượng Play) trên thanh công cụ của Android Studio.
   - Cách 2: Chạy lệnh sau trong terminal:
     ```sh
     flutter run
     ```

*Lưu ý: Nếu gặp lỗi "'flutter' is not recognized", hãy kiểm tra lại biến môi trường PATH và khởi động lại Android Studio.*
