# SỔ PORT — IT-MANAGER (Docker / Proxmox)

*Cập nhật: 24/11/2026. Chỉ là sổ GitHub, **không phải phép quét trực tiếp Docker host**.*

## 1. Kết quả thực tế từ ảnh Portainer

- **SpiderFoot** đang có 1 container `spiderfoot`, image `spiderfoot`, trạng thái `running`, published **`5001:5001`** tại thời điểm ảnh.
- Cấu hình đã sửa trong fork **`hoangthang0106/spiderfoot`**: `docker-compose.yml` và `Dockerfile` trên **`master` và `main`**; ứng dụng nghe **18994**, Caddy gateway publish `LAN_IP:18994`; giữ volume **`spiderfoot-data`**; chỉ yêu cầu user/password tự đặt.
- **Chưa có bằng chứng Portainer đã redeploy** và chưa có kết quả quét host port **18994**. File GitHub không tự làm container đang chạy đổi port.
- [Hướng dẫn cập nhật SpiderFoot cũ, không xóa dữ liệu](https://github.com/hoangthang0106/spiderfoot/blob/main/PORTAINER_FIX_PORT_18994.vi.md).

## 2. Dãy OSINT ưu tiên theo yêu cầu mới

| Ứng dụng | Host port ưu tiên | GitHub fork | Cần làm tiếp |
|---|---:|---|---|
| SpiderFoot | **18994** | [hoangthang0106/spiderfoot](https://github.com/hoangthang0106/spiderfoot) | Đã commit, đang chờ bạn Update Stack |
| OpenOSINT | **18995** | [hoangthang0106/OpenOSINT](https://github.com/hoangthang0106/OpenOSINT) | Chưa sửa fork, đợi xử lý từng ứng dụng |
| Maigret Web | **18996** | [hoangthang0106/maigret](https://github.com/hoangthang0106/maigret) | Chưa sửa fork, đợi xử lý từng ứng dụng |
| PhoneInfoga | **18997** | [hoangthang0106/phoneinfoga](https://github.com/hoangthang0106/phoneinfoga) | Chưa sửa fork, đợi xử lý từng ứng dụng |
| Social Analyzer | **18998** | [hoangthang0106/social-analyzer](https://github.com/hoangthang0106/social-analyzer) | Chưa sửa fork, đợi xử lý từng ứng dụng |

**Không đổi đồng loạt 4 fork còn lại:** đã có khả năng người dùng cài ứng dụng khác từ Git; thay đổi đồng loạt có thể kích hoạt GitOps update và đổi port ứng dụng đang chạy mà chưa kiểm tra.

Dải `29001–29005` là quy hoạch cũ, **tạm ngừng dùng cho các triển khai mới**. Hiện các fork số 2–5 còn chứa giá trị 29002–29005 trong Compose, chưa được cập nhật. `29001` đã bỏ khỏi bản cấu hình SpiderFoot.

## 3. Port lịch sử đã trao đổi

| Port host | Dịch vụ | Trạng thái chứng cứ |
|---:|---|---|
| 18889 | QRForge | Có URL được cung cấp, chưa xác minh trên host |
| 18890 | qrframe | Cấu hình đã chuẩn bị |
| 18891 | n8n | Dự kiến |
| 18892 | Immich | Compose đã chuẩn bị |
| 18993 | Stirling-PDF | Compose trên GitHub, chưa xác nhận chạy |
| 8080 | Snipe-IT Synology | Compose từng kiểm tra, host khác có thể dùng trùng |
| 9090 | GLPI Synology | Compose từng kiểm tra |
| 8006 | Proxmox | Port mặc định, host chưa xác minh |
| 9443 | Portainer | Port mặc định, host chưa xác minh |
| 8787 | IT Knowledge Hub | Port đề xuất |
| 8088 | Caddy thử nghiệm | Chưa xác nhận đã cài |
| **5001** | **SpiderFoot (ảnh ngày 24/11)** | **Đã quan sát running/published; sẽ bỏ sau Update Stack** |

## 4. Quy trình bắt buộc trước khi cài

1. Đọc [registry.json](./registry.json) để kiểm tra port đã được gán hoặc đã dành.
2. Trên **đúng Docker VM/LXC/NAS** chạy các lệnh chỉ đọc [CHECK_PORTS.sh](./CHECK_PORTS.sh) hoặc `docker ps -a`, `ss -lntup`, `docker inspect HostConfig.PortBindings`.
3. Chỉ khi xác nhận port còn trống mới triển khai. Cùng port trên **host khác** có thể không xung đột. Port **nội bộ container** thuộc namespace riêng không có nghĩa là host port.
4. Sau khi xác nhận triển khai thành công, mới cập nhật trạng thái trong sổ thành *đã chạy/đã xác minh*. Mặc định mọi mục chỉ là *đề xuất/đã commit trong fork*.
5. Không lưu IP nội bộ thật, mật khẩu, token, dữ liệu tra cứu cá nhân vào repository GitHub công khai; không tự ý xóa Stack/volume hoặc sửa firewall.
