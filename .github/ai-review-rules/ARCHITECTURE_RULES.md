# Cấu trúc Phân lớp PubStar SDK (Flutter)

PubStar SDK được thiết kế theo mô hình phân lớp (Layered Architecture) để tách biệt giữa API cung cấp cho người dùng (Application Layer) và logic giao tiếp với hệ điều hành (Native Integration Layer).

## 1. Public API Layer (Tầng Giao Tiếp Trực Tiếp với App)
Tầng này định nghĩa những gì mà developer tích hợp SDK sẽ nhìn thấy và sử dụng.
* **`pubstar_io.dart`**: Entry point, export các thành phần public.
* **`pubstar_io_core.dart`**: Lớp facade chính cung cấp các hàm API (init, loadAd, showAd, ...).
* **`pubstar_types.dart`**: Định nghĩa các kiểu dữ liệu, models, callbacks công khai.

## 2. Platform Communication Layer (Tầng Giao Tiếp Native)
Tầng này chịu trách nhiệm chuyển đổi dữ liệu và gọi lệnh giữa môi trường Dart và Native (iOS/Android).
* **`pubstar_io_platform_interface.dart`**: Hợp đồng (Contract) quy định các phương thức giao tiếp. Đảm bảo tính trừu tượng để có thể mock khi test.
* **`pubstar_io_method_channel.dart`**: Lớp thực thi giao tiếp thực tế bằng cách sử dụng `MethodChannel` của Flutter. Truyền arguments xuống Native và nhận kết quả trả về.
* **`callback_handler.dart`**: Quản lý Event Channel hoặc các callback từ Native dội ngược lên (ví dụ: `onAdLoaded`, `onAdFailedToLoad`).

## 3. Presentation/View Layer (Tầng Hiển Thị UI)
Xử lý việc nhúng các View của Native (UIView trên iOS, View trên Android) vào cây Widget của Flutter thông qua `PlatformView`.
* **`pubstar_ad_view.dart`**: Component hiển thị các format quảng cáo tĩnh.
* **`pubstar_video_ad_view.dart`**: Component chuyên biệt có chứa player hoặc logic xử lý cho quảng cáo Video.

## 4. Core Utilities & Error Handling (Tầng Tiện ích & Xử lý lỗi)
Các file hỗ trợ dùng chung cho toàn bộ dự án SDK.
* **`error_code.dart`**: Định nghĩa danh sách mã lỗi chuẩn.
* **`pubstar_io_exception.dart`**: Object lỗi chuẩn hóa để ném về cho Public API Layer.
* **`method_channel_name.dart`**: Quản lý các String constants định danh cho MethodChannels và EventChannels.

## Luồng Dữ Liệu Tiêu Biểu (Data Flow)
**App gọi SDK -> SDK gọi Native:**
Application -> `pubstar_io_core.dart` -> `pubstar_io_platform_interface.dart` -> `pubstar_io_method_channel.dart` -> Native OS.

**Native phản hồi -> SDK -> App:**
Native OS -> `callback_handler.dart` -> Đóng gói lỗi bằng `pubstar_io_exception.dart` (nếu có) -> Application.

# Kiến trúc PubStar SDK (Flutter)

Tài liệu này mô tả cấu trúc thư mục và vai trò của từng file trong dự án PubStar SDK dành cho nền tảng Flutter. SDK này đóng vai trò cầu nối giữa ứng dụng Flutter và nền tảng Native (iOS/Android).

## Cấu trúc thư mục (Directory Structure)

```text
lib/
├── src/
│   ├── callback_handler.dart
│   ├── error_code.dart
│   ├── method_channel_name.dart
│   ├── pubstar_ad_view.dart
│   ├── pubstar_io_core.dart
│   ├── pubstar_io_exception.dart
│   ├── pubstar_io_method_channel.dart
│   ├── pubstar_io_platform_interface.dart
│   ├── pubstar_types.dart
│   └── pubstar_video_ad_view.dart
└── pubstar_io.dart
```

## Chi tiết các thành phần (Component Details)

### 1. File Export Chính
* **`lib/pubstar_io.dart`**: File entry point của SDK. Nơi export các class, interface và method cần thiết để Application (tầng ứng dụng) có thể import và sử dụng.

### 2. Thư mục `lib/src/` (Nội bộ SDK)
* **`pubstar_io_core.dart`**: Chứa các API chính để tầng Application tương tác với SDK (ví dụ: khởi tạo SDK, gọi load quảng cáo).
* **`pubstar_types.dart`**: Chứa định nghĩa các interface, data model, enum được export cho Application sử dụng.
* **`pubstar_io_platform_interface.dart`**: Định nghĩa Platform Interface chuẩn (thường dùng chung cho pattern `plugin_platform_interface` của Flutter) để quy định các hàm tương tác qua Method Channel.
* **`pubstar_io_method_channel.dart`**: Implementation cụ thể của Platform Interface, cấu hình phần tương tác trực tiếp từ SDK Flutter xuống Native code (iOS/Android) thông qua `MethodChannel`.
* **`callback_handler.dart`**: Xử lý các listener/callback. Lắng nghe các event từ tầng Native đẩy lên và map chúng về ứng dụng Flutter đang tích hợp SDK.
* **`pubstar_ad_view.dart`**: Chứa code định nghĩa Widget UI (Platform View) gọi từ Flutter xuống tầng View Native để hiển thị quảng cáo thông thường (như Banner, Native Ad).
* **`pubstar_video_ad_view.dart`**: Tương tự như `pubstar_ad_view.dart` nhưng chuyên biệt cho việc liên kết với tầng Native để hiển thị Video Ad.
* **`error_code.dart`**: Chứa các hằng số (constants) định nghĩa các loại mã lỗi (Error Codes) có thể xảy ra trong quá trình SDK hoạt động.
* **`pubstar_io_exception.dart`**: Class Exception tùy chỉnh, dùng để đóng gói các lỗi từ tầng Native gọi lên, giúp tầng Application dễ dàng catch và handle lỗi đồng nhất.
* **`method_channel_name.dart`**: Chứa các hằng số (constants) như tên của Method Channel, Event Channel hoặc các key String dùng chung trong nội bộ SDK để tránh hardcode.

## Hướng dẫn Refactor cho AI
* Khi refactor logic gọi xuống Native, hãy tập trung vào `pubstar_io_method_channel.dart`.
* Khi thêm API mới cho user sử dụng, phải định nghĩa ở `pubstar_io_platform_interface.dart`, implement ở `pubstar_io_method_channel.dart`, và bọc lại ở `pubstar_io_core.dart`.