# IT-MANAGER — Sổ cấp phát PORT Docker / Proxmox

**Mốc đã dùng gần nhất do người dùng xác nhận: 18893 (Synaplan Lite).** Lần cài mới tiếp theo bắt đầu từ 18894.

- [Sổ port và trạng thái thực tế / đề xuất](ports/PORT_REGISTRY.vi.md)
- [Registry dạng JSON](ports/registry.json)
- [Script kiểm tra port không thay đổi hệ thống](ports/CHECK_PORTS.sh)
- [Hướng dẫn cài trên Android](ports/SETUP_ANDROID_OSINT_5.vi.md)

Đã cấu hình trên các fork GitHub: **18894 SpiderFoot, 18895 OpenOSINT, 18896 Maigret, 18897 PhoneInfoga, 18898 Social Analyzer**, ứng viên tiếp theo là **18899**.

Quy tắc: mặc định mapping gateway **N:N** và backend nghe port N bên trong Docker, không publish port khác. **Không tuyên bố port còn trống** nếu chưa có lệnh kiểm tra trực tiếp trên đúng Docker endpoint. Ảnh cũ SpiderFoot đang dùng `5001:5001`; phải update Stack hiện có để thay đổi, không xóa volume hoặc tạo Stack trùng. Tránh ghi IP LAN thật, mật khẩu, account hoặc token trong repository công khai.
