# IT-MANAGER — Sổ cấp phát PORT Docker / Proxmox

Nguồn quy hoạch port cho các lần cài ứng dụng tiếp theo. **Không chứa IP nội bộ thật, mật khẩu, token hay VMID**. Repo này công khai; chỉ ghi số port/cấu hình dự kiến.

- [Sổ port tiếng Việt](ports/PORT_REGISTRY.vi.md)
- [Sổ máy đọc được (JSON)](ports/registry.json)
- [Kiểm tra port tại Docker host (chỉ đọc)](ports/CHECK_PORTS.sh)

**Nguyên tắc**: Mọi port trong sổ là *đề xuất/đã giữ chỗ*, không tự động có nghĩa đang chạy. Trước Deploy phải chạy kiểm kê trên **đúng VM/LXC hoặc NAS có Docker**, kiểm tra port đang nghe, các container đã dừng và các service ngoài Docker. Không được đổi port nội bộ của ứng dụng chỉ vì trùng số với container khác: mỗi container có namespace mạng riêng.

Dải OSINT ưu tiên sau yêu cầu mới: **18994–18998**. SpiderFoot 18994 đã sửa trên GitHub, cần Update Stack đang chạy; OpenOSINT/Maigret/PhoneInfoga/Social Analyzer mới giữ chỗ 18995–18998, chưa sửa fork cho đến khi xử lý từng ứng dụng. Dải 290xx tạm ngừng cấp mới. Không kết luận port trống khi chưa kiểm tra Docker host.
