# Tiêu chuẩn Review Code Flutter & Dart cho AI

Với tư cách là người review code, bạn phải tuân thủ nghiêm ngặt các tiêu chuẩn của cộng đồng `Effective Dart` và `Flutter best practices`. Hãy kiểm tra PR/Merge Request dựa trên các tiêu chí sau:

## 1. Tiêu chuẩn ngôn ngữ Dart (Effective Dart)
- **Sử dụng `const` và `final`**: Bắt buộc sử dụng `const` cho các biến biên dịch và `final` cho các biến chỉ gán một lần. Chỉ dùng `var` khi thực sự cần thiết.
- **Xử lý Bất đồng bộ (Async/Await)**: Mọi thao tác gọi API, đọc/ghi file hoặc gọi `MethodChannel` đều phải được bọc trong `try-catch`. Không sử dụng `.then()` trừ khi xử lý các luồng cực kỳ đơn giản.
- **Null Safety**: Đảm bảo an toàn null. Hạn chế tối đa việc sử dụng toán tử `!` (bang operator) để ép kiểu non-null. Khuyến khích sử dụng `??` hoặc kiểm tra `if (obj != null)`.

## 2. Tiêu chuẩn Framework Flutter
- **Tối ưu Widget Tree**: Bắt buộc thêm từ khóa `const` trước các Widget constructor không thay đổi trạng thái để tránh rebuild không cần thiết.
- **Tách nhỏ Widget**: Nếu một hàm `build()` dài hơn 100 dòng hoặc chứa quá nhiều logic lồng nhau (nested trees), hãy yêu cầu tách thành các `StatelessWidget` nhỏ hơn thay vì sử dụng các hàm trả về Widget (helper methods).
- **Quản lý State**: Tránh lạm dụng `setState` ở các Widget lớn. Đối với các logic phức tạp, cần tách biệt khỏi UI (ví dụ: sử dụng BLoC, Riverpod, hoặc Provider).

## 3. Kiến trúc và Giao tiếp Native (Đặc thù SDK)
- **Platform Channels**: Các lệnh gọi qua `MethodChannel` hoặc `EventChannel` (ví dụ: `pubstar_io_method_channel.dart`) bắt buộc phải kiểm tra kiểu dữ liệu trả về từ Native một cách nghiêm ngặt và bắt `PlatformException`.
- **Public API**: Mọi class, hàm được export ra cho người dùng cuối (tại `pubstar_io.dart`) đều phải có doc comment (`///`) mô tả rõ chức năng, tham số và giá trị trả về.

## Định dạng Phản hồi của AI
- Chỉ ra dòng code vi phạm.
- Trích dẫn ngắn gọn quy tắc bị vi phạm.
- Cung cấp đoạn code gợi ý để sửa (Code Snippet).