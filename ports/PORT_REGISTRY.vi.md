# SỔ PORT IT-MANAGER — BẢN DÙNG ĐỂ CẤP PORT MỚI

*Cập nhật ngày 26/11/2026; lưu trữ lâu dài trên GitHub. Không có kết nối trực tiếp tới Portainer/Docker để xác nhận cổng đang trống.*

## 1. Port cuối cùng người dùng đã xác nhận sử dụng

**18893 — Synaplan Lite**. Theo lịch sử triển khai, người dùng đã cài đặt và truy cập ứng dụng ở host port này; hôm nay tiếp tục xác nhận **18893 là mốc cuối**. **Không suy đoán port nội bộ** của ứng dụng khi chưa có Compose.

## 2. Cấp lần lượt từ 18894, chỉ tính ứng dụng triển khai thực tế

| STT | Ứng dụng | Host:Container đã cấu hình | Fork | Trạng thái |
|---:|---|---|---|---|
| 1 | SpiderFoot | **18894:18894/TCP** | [hoangthang0106/spiderfoot](https://github.com/hoangthang0106/spiderfoot/blob/main/docker-compose.yml) | Ảnh Portainer: đang chạy cổng cũ 5001:5001; GitHub đã sửa, cần Update Stack |
| 2 | Freebie Radar | **18895:18895/TCP** | [hoangthang0106/freebie-radar](https://github.com/hoangthang0106/freebie-radar/blob/main/docker-compose.yml) | Fork đã sửa 26/11/2026; chưa xác minh triển khai |
| 3 | Maigret Web | **18896:18896/TCP** | [hoangthang0106/maigret](https://github.com/hoangthang0106/maigret/blob/main/docker-compose.yml) | Đã sửa fork; chưa xác minh chạy trên Docker |
| 4 | PhoneInfoga | **18897:18897/TCP** | [hoangthang0106/phoneinfoga](https://github.com/hoangthang0106/phoneinfoga/blob/master/docker-compose.yml) | Đã sửa fork; chưa xác minh chạy trên Docker |
| 5 | Social Analyzer | **18898:18898/TCP** | [hoangthang0106/social-analyzer](https://github.com/hoangthang0106/social-analyzer/blob/main/docker-compose.yml) | Đã sửa fork; chưa xác minh chạy trên Docker |
| — | OpenOSINT (chưa cài xác nhận) | **Chưa cấp cổng mới**; fork cũ đang để 18895 nên xung đột nếu dùng cùng Freebie Radar | [hoangthang0106/OpenOSINT](https://github.com/hoangthang0106/OpenOSINT/blob/main/docker-compose.yml) | Cần cấp lại và sửa fork khi người dùng yêu cầu cài |

Theo yêu cầu, **ưu tiên host port = container port và ứng dụng phải lắng nghe đúng port đó**; Freebie Radar đã chỉnh cả PORT và healthcheck để dùng **18895:18895**. Chỉ dùng cặp port khác số nếu ứng dụng không hỗ trợ đổi cổng và người dùng đồng ý. Không tự thêm Caddy, gateway hay container phụ. Các fork OSINT chuẩn bị trước đây có thể còn dùng cấu hình khác; **không coi đã cài nếu chưa xác minh Portainer**. SpiderFoot đã được sửa fork theo hướng một container, nhưng trạng thái đang chạy chưa xác minh.

**18896** là số tiếp theo *sau ứng dụng thực sự được ưu tiên cài*, nhưng cũng là ứng viên từng cấu hình cho Maigret. Khi cài thêm phải kiểm tra Docker host thực tế và thay đổi các kế hoạch chưa triển khai để tránh trùng.

## 3. Những port khác từng ghi nhận

| Host port | Dịch vụ | Bằng chứng |
|---:|---|---|
| 18889 | QRForge | Có URL LAN người dùng đưa, không xác minh trực tiếp |
| 18890 | qrframe | Cấu hình đã chuẩn bị, trạng thái triển khai chưa xác minh |
| 18891 | n8n | Có kế hoạch dùng, chưa xác minh |
| 18892 | Immich | Có Compose đã chuẩn bị, chưa xác minh |
| **18893** | **Synaplan Lite** | **Người dùng đã xác nhận truy cập được trong trao đổi trước và nhắc lại hôm nay** |
| 18993 | Stirling-PDF | **Đề xuất trước đây**, chưa xác minh đang chạy; không được nhầm với 18893 |
| 9090 | GLPI Synology | Đã có trong Compose, chưa xác minh đang chạy |
| 8080 | Snipe-IT Synology | Đã có trong Compose, trên host riêng có thể không xung đột |
| 9443 | Portainer | Port mặc định, cần kiểm tra host |
| 8006 | Proxmox VE | Port mặc định, cần kiểm tra host |
| 5001 | SpiderFoot | **Ảnh Portainer ngày 24/11: đang Running/publish 5001:5001; cần cập nhật Stack cũ để gỡ** |

Dãy 18994–18998 và 29001–29005 là **quy hoạch cũ**, đã bị thay bằng 18894–18898; không tự ý tái cấp khi chưa xem hệ thống thực tế.

## 3A. Kiểm kê từ ảnh Portainer gửi ngày 24/11/2026

**Chỉ ghi những mapping Published Ports nhìn thấy trong ảnh**; không phải lệnh kiểm tra trực tiếp, và không xác nhận trạng thái running cho mọi dòng.

| Dịch vụ | Published Ports (host:container) |
|---|---|
| IT Tools | `8181:80` |
| LibreNMS | `8089:8000` |
| Mikrodash IT | `13081:3081` |
| Mini QR | `18285:8080` |
| Personal Web | `8088:4321` |
| Portainer | `9443:9443` |
| QRForge | `18889:8080` |
| qrframe | `18890:18090` |
| Immich | `18892:2283` |
| Synaplan Lite | **`18893:80`** |
| SpiderFoot (container cũ trong ảnh) | **`5001:5001`** |
| Stirling-PDF | **`18993:8080`** |
| Trend app | `8080:8080` |
| Zabbix Web | `8380:8080` |

`18891` đã được nhắc đến cho n8n nhưng **không có trong các dòng ảnh đã xem**. Port `18993` là Stirling-PDF, hoàn toàn khác với port `18893` của Synaplan. Không được cấp trùng hai port này.

**Điểm cần thao tác:** hình ảnh SpiderFoot vẫn hiển thị `5001:5001`, trong khi file GitHub đã là `18894:18894`. Cần cập nhật Stack đang chạy, giữ nguyên volume, và kiểm tra `18894` trống trên đúng Docker host trước. Đích trên fork là `18894:18894` trực tiếp trên SpiderFoot (không bắt buộc gateway), **không có host-published 5001**.

## 4. Quy trình khi cài ứng dụng mới

1. Đọc [registry.json](./registry.json) và ưu tiên số tiếp theo sau ứng dụng thực tế, hiện **18896** nếu chưa bị chiếm. Port được ghi trong các fork chưa cài không có nghĩa là đã được dùng; khi thay đổi ưu tiên, cập nhật sổ và cảnh báo Compose cũ trùng.
2. Trên **đúng VM/LXC/NAS chạy Docker**, dùng [CHECK_PORTS.sh](./CHECK_PORTS.sh) hoặc lệnh đọc `ss -lntup`, `docker ps -a`, `docker inspect HostConfig.PortBindings`. Kiểm tra cả container đã dừng.
3. Mặc định cấu hình **N:N**, đồng bộ cổng lắng nghe ứng dụng và healthcheck với N, không tự thêm Caddy/gateway. Nếu app không hỗ trợ đổi port nội bộ, giải thích trước khi dùng N:M.
4. Không được xem việc cập nhật GitHub là đã triển khai. Sau khi Portainer hiện ứng dụng Running và đúng Published Ports, mới cập nhật trạng thái.
5. Không xóa Stack/volume, không đổi firewall, không làm gián đoạn ứng dụng khác để lấy port. Luôn để người dùng tự nhập mật khẩu trong Portainer, không commit mật khẩu vào GitHub công khai.

**Lưu ý bảo mật:** Giao diện qua HTTP LAN không mã hóa đường truyền; cần mạng tin cậy hoặc HTTPS/VPN, không NAT ra Internet. Freebie Radar cần ADMIN_TOKEN để khóa các API quản trị.
