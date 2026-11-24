# HƯỚNG DẪN ANDROID — CÀI 5 OSINT WEB QUA PORTAINER

*Cập nhật 24/11/2026. Các file Git đã chuẩn bị; chưa xác minh IP/port thực tế, chưa chạy ứng dụng trên máy.*

## A. Chọn đúng Docker host, kiểm tra port

1. Chrome Android → Portainer → Environments → chọn đúng Docker endpoint chứa VM/LXC muốn cài.
2. Chọn Containers để xem đã có Stack/app chưa, Stacks xem các project hiện tại.
3. **Chỉ đọc**, trong Console của đúng VM/LXC trên Proxmox (không phải Proxmox host), chạy:

```bash
docker ps -a --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'
sudo ss -ltnp
docker ps -aq | xargs -r docker inspect --format '{{.Name}} {{json .HostConfig.PortBindings}}'
```

Chỉ tiếp tục nếu cổng 29001–29005 được xác minh còn trống. Các cổng đã giữ chỗ trong [Sổ port](./PORT_REGISTRY.vi.md), không phải bằng chứng đang chạy.

## B. Tạo bcrypt hash chỉ bằng Portainer

Cách dễ dùng trên điện thoại (không cần SSH):

1. Portainer → **Stacks → Add stack → Repository**.
2. Name: `osint-hash-helper`.
3. Repository URL: `https://github.com/hoangthang0106/thang`.
4. Reference: `refs/heads/main`. Compose path: `ports/caddy-hash-helper.yml`.
5. Deploy Stack phụ, không publish bất cứ port nào. Trên **Containers** chọn `osint-hash-helper`, mở **Console** → `/bin/sh` → Connect.
6. Trong console nhập `caddy hash-password --algorithm bcrypt` rồi Enter, nhập mật khẩu mạnh vào prompt (ký tự không hiện trên console), Enter và sao chép chuỗi bcrypt trả về, ví dụ bắt đầu `$2a$` hoặc `$2b$`.
7. Dán hash này vào biến `OSINT_AUTH_HASH` của từng Stack OSINT. Khi website hỏi đăng nhập, dùng **mật khẩu gốc**, không phải hash.
8. Sau khi đã lưu hash an toàn, có thể chủ động xóa Stack phụ không có volume (không xóa nhầm các Stack khác).

**Lưu ý:** Portainer/Docker admin có thể xem giá trị biến môi trường, và Basic Auth trên HTTP chưa mã hóa đường truyền. Giữ trong LAN tin cậy và ưu tiên HTTPS nội bộ.

## C. Cài 5 Stack theo thứ tự

Dùng thao tác giống nhau cho mỗi app:

Portainer → Stacks → Add stack → Repository. Nhập Name và Repo trong bảng. Dùng `refs/heads/portainer-lan` cho Reference và `portainer-compose.yml` cho Compose path. Kéo xuống Environment variables và thêm ba dòng:
- `LAN_IP` = IP thực của VM/LXC Docker
- `OSINT_AUTH_USER` = tên tài khoản muốn dùng để mở website, ví dụ `itadmin`
- `OSINT_AUTH_HASH` = hash từ bước B

Không cần thêm biến port nếu dùng mặc định, nhưng **phải xác minh port đó trống trước**. Chỉ khi đủ mới Deploy.

| Thứ tự | Stack name | Fork repo | Port mặc định | Công dụng |
|---|---|---|---:|---|
| 1 | `osint-spiderfoot` | `https://github.com/hoangthang0106/spiderfoot` | 29001 | Tra cứu OSINT đa nguồn email/username/phone/domain/IP; xem liên kết dữ liệu |
| 2 | `osint-openosint` | `https://github.com/hoangthang0106/OpenOSINT` | 29002 | Chat/web điều tra, Holehe (email) + Sherlock (username); PhoneInfoga chưa có sẵn trong Dockerfile |
| 3 | `osint-maigret` | `https://github.com/hoangthang0106/maigret` | 29003 | Tìm hồ sơ công khai theo username và xuất báo cáo |
| 4 | `osint-phoneinfoga` | `https://github.com/hoangthang0106/phoneinfoga` | 29004 | Tra cứu metadata số điện thoại và dấu vết công khai |
| 5 | `osint-social-analyzer` | `https://github.com/hoangthang0106/social-analyzer` | 29005 | Tìm/phân tích profile mạng xã hội theo username |

Với ứng dụng 1, 2, 5 có `build:`. Nếu Portainer báo lỗi build image từ Git: xem hướng dẫn **Phương án B** trong `PORTAINER.vi.md` từng fork, cần build trên Docker endpoint đúng và đổi Compose path sang `portainer-image-only.yml`. Không chuyển sang Compose image-only trước khi có image đã build.

Ứng dụng 3 và 4 dùng image dựng sẵn, phù hợp nhất để kiểm tra quy trình lần đầu trên điện thoại; nhưng thứ tự quy hoạch vẫn là 1→5.

## D. Kiểm tra sau khi cài từng cái

1. Portainer → Stacks → Stack vừa tạo → Containers: kiểm tra app và gateway đang Running.
2. Logs → xem error, lỗi cấu hình, pull image, build, database, memory.
3. Trên Android cùng mạng LAN: mở `http://LAN_IP:29001`, lần lượt các cổng 29002/29003/29004/29005 sau khi cài đúng app.
4. Trình duyệt yêu cầu Basic Auth: `OSINT_AUTH_USER` và **mật khẩu gốc**.
5. Nếu có `502 Bad Gateway`, gateway đang chạy nhưng backend chưa sẵn sàng hoặc không kết nối được — xem Logs backend. Nếu `connection refused`, kiểm tra IP/port và gateway. Nếu Docker báo `port is already allocated`, dừng, kiểm kê lại host port; **không stop/xóa ứng dụng khác**.
6. Khi hoạt động, ghi trạng thái *đã xác minh/đã cài* vào sổ nội bộ; chỉ ghi thông tin không nhạy cảm lên GitHub công khai.

## E. Link từng hướng dẫn đầy đủ

1. https://github.com/hoangthang0106/spiderfoot/blob/portainer-lan/PORTAINER.vi.md
2. https://github.com/hoangthang0106/OpenOSINT/blob/portainer-lan/PORTAINER.vi.md
3. https://github.com/hoangthang0106/maigret/blob/portainer-lan/PORTAINER.vi.md
4. https://github.com/hoangthang0106/phoneinfoga/blob/portainer-lan/PORTAINER.vi.md
5. https://github.com/hoangthang0106/social-analyzer/blob/portainer-lan/PORTAINER.vi.md

**An toàn:** Dùng với thông tin sở hữu hoặc có ủy quyền, không lạm dụng quét tài khoản người khác. Các nguồn công khai có thể thiếu/sai; không dịch vụ nào chứng minh được tất cả tài khoản từng đăng ký bằng một email/số điện thoại.
