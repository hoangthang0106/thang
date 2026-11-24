> **CẬP NHẬT 24/11/2026 — SpiderFoot:** ảnh Portainer xác nhận container hiện tại đang publish `5001:5001`; GitHub fork đã sửa `docker-compose.yml` và `Dockerfile` sang **18994** trên `master`/`main`, giữ tên volume `spiderfoot-data`, nhưng **chưa cập nhật Stack đang chạy** và chưa xác minh 18994 trống trên host. Ưu tiên file [Hướng dẫn sửa 18994](https://github.com/hoangthang0106/spiderfoot/blob/main/PORTAINER_FIX_PORT_18994.vi.md). **18995–18998** được ghi là *nguyện vọng chuyển sang dải cũ*, 4 fork còn lại chưa sửa, tránh bất ngờ redeploy qua GitOps. Không sử dụng thêm dải 290xx khi chưa hỏi lại.

# SỔ ĐĂNG KÝ PORT — IT-MANAGER

*Cập nhật: 24/11/2026. Dữ liệu dựa trên cấu hình đã trao đổi và các fork GitHub. **Không phải kết quả kiểm tra máy Docker đang chạy**.*

## Dải port quy hoạch

- **29001–29099**: dành riêng cho công cụ OSINT; số tiếp theo đề xuất **đợi xác nhận cổng**.
- **29100–29999**: dành cho những ứng dụng web/Docker cài tiếp theo; số đầu tiên đề xuất **29100**.
- **18889–18998**: dải cũ từng trao đổi, **không cấp lại** khi chưa kiểm kê thiết bị thực tế.
- Port **nội bộ container không cần duy nhất toàn hệ thống**: ứng dụng trong mỗi container có network namespace riêng.

## 5 port OSINT mới đã ghi vào GitHub

| Ứng dụng | Host TCP | Nội bộ container | Fork GitHub | Trạng thái |
|---|---:|---:|---|---|
| SpiderFoot | **18994** | 18994 | [hoangthang0106/spiderfoot](https://github.com/hoangthang0106/spiderfoot/tree/portainer-lan) | Giữ chỗ, chưa xác minh đang chạy |
| OpenOSINT | **29002** | 8080 | [hoangthang0106/OpenOSINT](https://github.com/hoangthang0106/OpenOSINT/tree/portainer-lan) | Giữ chỗ, chưa xác minh đang chạy |
| Maigret Web | **29003** | 5000 | [hoangthang0106/maigret](https://github.com/hoangthang0106/maigret/tree/portainer-lan) | Giữ chỗ, chưa xác minh đang chạy |
| PhoneInfoga | **29004** | 5000 | [hoangthang0106/phoneinfoga](https://github.com/hoangthang0106/phoneinfoga/tree/portainer-lan) | Giữ chỗ, chưa xác minh đang chạy |
| Social Analyzer | **29005** | 9005 | [hoangthang0106/social-analyzer](https://github.com/hoangthang0106/social-analyzer/tree/portainer-lan) | Giữ chỗ, chưa xác minh đang chạy |

Ứng dụng không publish trực tiếp cổng nội bộ. Chỉ Caddy gateway trong từng Stack được publish ra `LAN_IP:2900X`. Có thể đổi host port thủ công thông qua biến `*_HOST_PORT`, nhưng **phải cập nhật lại sổ này sau khi Deploy**.

## Port cũ / cấu hình từng nhắc đến

| Port TCP | Dịch vụ | Mức độ xác nhận |
|---:|---|---|
| 18889 | QRForge | observed url not live verified |
| 18890 | qrframe | documented configuration |
| 18891 | n8n | planned |
| 18892 | Immich | documented configuration |
| 18993 | Stirling-PDF | committed in fork unverified |
| 18994 | SpiderFoot old plan | replaced do not reassign until checked |
| 18995 | OpenOSINT old plan | replaced do not reassign until checked |
| 18996 | Maigret old plan | replaced do not reassign until checked |
| 18997 | PhoneInfoga old plan | replaced do not reassign until checked |
| 18998 | Social Analyzer old plan | replaced do not reassign until checked |
| 9090 | GLPI Synology | documented compose not verified |
| 8080 | Snipe-IT Synology | documented compose not verified |
| 8787 | IT Knowledge Hub | app template default unverified |
| 8088 | Caddy testing | proposed unverified |
| 9443 | Portainer HTTPS | standard port not verified |
| 8006 | Proxmox VE | standard port not verified |

Danh sách không phản ánh đầy đủ toàn bộ hạ tầng; các host khác nhau có thể dùng trùng host port mà không xung đột. DB nội bộ 3306 không bị publish trong các Compose từng xem xét.

## Quy trình cài phần mềm mới — BẮT BUỘC

1. Mở [registry.json](./registry.json), kiểm tra cả `allocations` và `historical_records`; tìm khoảng chưa được phân bổ theo nhóm.
2. Trên **đúng VM/LXC, NAS hoặc Docker endpoint**, đọc `docker ps -a`, `ss -lntup` và các `HostConfig.PortBindings`, kể cả container đã dừng. Kiểm tra dịch vụ ngoài Docker.
3. Nếu chưa có bằng chứng cổng trống: đánh dấu **đề xuất/giữ chỗ**, không đánh dấu *đã xác minh*.
4. Sau khi xác nhận, cập nhật JSON/Markdown + Compose trong fork và ghi ngày, host đích **trong sổ riêng tư** (không đưa IP nội bộ hoặc mật khẩu lên GitHub công khai).
5. Không tự triển khai, đổi port container đang chạy, sửa firewall hoặc xóa Stack nếu chưa có thao tác xác nhận rõ ràng.

[CHECK_PORTS.sh](./CHECK_PORTS.sh) là kịch bản kiểm kê **chỉ đọc**. Có thể xem nội dung trước khi chạy.

## Lưu ý bảo mật

Repo `thang` đang là kho công khai, chỉ lưu port và tên phần mềm, **không ghi IP LAN, VMID, thông tin tài khoản, email cá nhân hay credentials**. Lịch sử và ảnh chụp chứa bí mật cần giữ trong kho riêng có kiểm soát quyền truy cập.
