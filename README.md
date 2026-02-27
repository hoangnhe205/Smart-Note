# Smart Note App

Ứng dụng ghi chú thông minh được xây dựng bằng Flutter, tập trung vào trải nghiệm người dùng tối giản và tính năng tự động lưu trữ dữ liệu bền vững.

**Định danh sinh viên:**
- **Họ và tên:** Nguyễn Việt Hoàng
- **Mã sinh viên:** 2351160522

## 1. GIỚI THIỆU TỔNG QUAN
Smart Note là một ứng dụng ghi chú cá nhân hoạt động hoàn toàn Offline. Ứng dụng cung cấp giao diện hiện đại theo chuẩn Material Design 3, hỗ trợ quản lý ghi chú thông qua các thao tác trực quan như tìm kiếm real-time, vuốt để xóa và tự động lưu trữ dữ liệu dưới dạng JSON.

## 2. CHỨC NĂNG CHÍNH
- **Quản lý ghi chú:** Thêm mới, xem chi tiết và chỉnh sửa ghi chú.
- **Tìm kiếm thông minh:** Lọc ghi chú ngay lập tức theo tiêu đề khi gõ vào thanh tìm kiếm.
- **Tự động lưu (Auto-save):** Không cần nút lưu, ứng dụng tự động đóng gói dữ liệu và lưu xuống thiết bị khi thoát màn hình soạn thảo.
- **Xác nhận xóa:** Hỗ trợ thao tác vuốt để xóa kèm hộp thoại xác nhận để tránh mất dữ liệu ngoài ý muốn.
- **Lưu trữ Offline:** Dữ liệu được lưu trữ bền vững qua SharedPreferences, không bị mất khi đóng ứng dụng hoặc khởi động lại máy.

## 3. LUỒNG ỨNG DỤNG (APP FLOW)
1. **Khởi động:** App đọc dữ liệu JSON từ bộ nhớ máy.
2. **Trang chủ:** Hiển thị danh sách ghi chú dạng lưới (Grid) 2 cột. Nếu chưa có dữ liệu, hiển thị trạng thái trống kèm hình ảnh minh họa.
3. **Thêm/Sửa:** Người dùng bấm nút (+) hoặc chọn một ghi chú cũ. Tại màn hình soạn thảo, viền các ô nhập liệu được ẩn đi để tạo cảm giác như trang giấy trắng.
4. **Thoát & Lưu:** Khi bấm nút Back hoặc vuốt cạnh để quay lại, ứng dụng tự động thực hiện tiến trình mã hóa JSON và lưu trữ.
5. **Cập nhật:** Trở ra màn hình chính, danh sách tự động làm mới dữ liệu mới nhất.

## 4. CHI TIẾT UI/UX
- **AppBar:** Luôn hiển thị định danh "Smart Note - [Nguyễn Việt Hoàng] - [2351160522]".
- **Layout:** Sử dụng GridView 2 cột với các Card bo góc, đổ bóng nhẹ.
- **Typography:** Tiêu đề in đậm (tối đa 1 dòng), nội dung tóm tắt nhạt màu (tối đa 3 dòng).
- **Thời gian:** Hiển thị định dạng `dd/MM/yyyy HH:mm` rõ ràng trên từng thẻ ghi chú.

## 5. YÊU CẦU KỸ THUẬT
- **Quản lý trạng thái:** Sử dụng gói `provider` để đồng bộ dữ liệu toàn ứng dụng.
- **Lưu trữ:** Sử dụng `shared_preferences` và `json_serializable` logic.
- **Kiến trúc:** Phân tách rõ ràng giữa Model, Repository và UI Components.

## 6. HƯỚNG DẪN CHẠY DỰ ÁN
1. Cài đặt Flutter SDK bản mới nhất.
2. Clone dự án và mở bằng Android Studio / VS Code.
3. Chạy lệnh cập nhật thư viện:
   ```sh
   flutter pub get
   ```
4. Khởi động máy ảo hoặc kết nối thiết bị thật.
5. Chạy ứng dụng:
   ```sh
   flutter run
   ```
