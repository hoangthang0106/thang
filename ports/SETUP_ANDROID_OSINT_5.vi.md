# HƯỚNG DẪN CÀI OSINT BẰNG ĐIỆN THOẠI — DÃY PORT 18894–18898

*Mốc đã dùng gần nhất: 18893 — Synaplan Lite. Mọi giá trị mới chỉ là cấu hình GitHub, không xác nhận Docker host đang trống.*

## A. Chuẩn bị chung

1. Trên Android mở **Portainer → Environments**, chọn đúng VM/LXC Docker.
2. Trước Deploy, kiểm tra host port trong [CHECK_PORTS.sh](./CHECK_PORTS.sh), hoặc bằng `ss -ltnp`, `docker ps -a` và `docker inspect HostConfig.PortBindings`.
3. Mỗi Stack nhập Environment variables `LAN_IP` (IP LAN của đúng Docker VM/LXC), `OSINT_AUTH_USER` (tự đặt), `OSINT_AUTH_PASSWORD` (mật khẩu mạnh tự đặt). **Không cần bcrypt hash; không commit bí mật vào GitHub**.
4. Git repository là public → Authentication `None`. Trong giai đoạn thử, không bật GitOps auto-update.
5. Nhánh mặc định và Compose path ở bảng dưới. **Không chọn file Compose cũ, không copy lệnh Docker Run với cổng mặc định 5001/8080**.

## B. Mỗi ứng dụng — thông tin cần nhập Portainer

| Thứ tự | Công cụ | Git repository | Reference | Compose path | Published ports sau khi Deploy |
|---:|---|---|---|---|---|
| 1 | SpiderFoot | https://github.com/hoangthang0106/spiderfoot.git | `refs/heads/main` | `docker-compose.yml` | **18894:18894** |
| 2 | OpenOSINT | https://github.com/hoangthang0106/OpenOSINT.git | `refs/heads/main` | `docker-compose.yml` | **18895:18895** |
| 3 | Maigret Web | https://github.com/hoangthang0106/maigret.git | `refs/heads/main` | `docker-compose.yml` | **18896:18896** |
| 4 | PhoneInfoga | https://github.com/hoangthang0106/phoneinfoga.git | `refs/heads/master` | `docker-compose.yml` | **18897:18897** |
| 5 | Social Analyzer | https://github.com/hoangthang0106/social-analyzer.git | `refs/heads/main` | `docker-compose.yml` | **18898:18898** |

- **1. SpiderFoot:** đang có Stack `spiderfoot` từ trước, ảnh Portainer vẫn chạy `5001:5001`; **update Stack hiện có** và giữ nguyên volume `spiderfoot-data`, không tạo Stack thứ hai. Compose mới dùng image local `spiderfoot:latest` không cần build; không bật Pull image.
- **2. OpenOSINT:** dùng API/Web UI + Holehe/Sherlock. Có `build:`; nếu Agent/remote không build được, dùng phương án build tại đúng Docker host rồi dùng `portainer-image-only.yml`, **không dùng image-only nếu chưa build**.
- **3. Maigret Web:** chủ yếu tìm hồ sơ công khai theo username; image `soxoj/maigret:web`, đặt `PORT=18896`, không cần build.
- **4. PhoneInfoga:** tìm dữ liệu công khai về số điện thoại; image `sundowndev/phoneinfoga:latest`, dùng `serve --port 18897`, không cần build.
- **5. Social Analyzer:** tìm hồ sơ theo username, dùng `PORT=18898`, bản mobile không kèm Selenium Grid; cần build Node 22, URL có đuôi `/app.html`.

## C. Sau khi Deploy

- Mở **Portainer → Stacks → đúng Stack → Containers**. Cần thấy app và gateway chạy; trong **Published Ports** phải hiển thị **1889N:1889N** trên gateway, không có host publish cổng app khác.
- Đăng nhập qua `http://LAN_IP:18894`, `http://LAN_IP:18895`, `http://LAN_IP:18896`, `http://LAN_IP:18897`, hoặc `http://LAN_IP:18898/app.html`.
- Nếu `reference not found`: kiểm tra repository/ref/path. Nếu `port is already allocated`: dừng thao tác triển khai, kiểm tra host, không xóa Stack khác. Nếu `502`: xem logs app và Caddy. Nếu lỗi `build`: xử lý build riêng, không chữa bằng đổi port.
- Chỉ sau khi bạn thấy Running và port đúng mới cập nhật trạng thái thực tế ở sổ GitHub. **Ứng viên cổng tiếp theo là 18899**, phải kiểm tra host trước.
- Basic Auth qua HTTP không mã hóa; chỉ dùng LAN tin cậy, không NAT ra Internet hoặc cấu hình HTTPS nội bộ.

Chi tiết từng fork: [Sổ port](./PORT_REGISTRY.vi.md).
