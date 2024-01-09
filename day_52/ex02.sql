-- Join table
-- SELECT users.*, public.group.name AS group_name FROM users
-- INNER JOIN public.group
-- ON users.group_id = public.group.id

-- các user có tên chứa từ khóa admin

-- SELECT users.* FROM users
-- INNER JOIN public.group
-- ON users.group_id = public.group.id
-- WHERE LOWER(public.group.name) LIKE LOWER('%admin')

-- C2: trả về danh sách bài viết của user chứa tên group chứa từ khóa admin và trạng thái true
-- Yêu cầu: thông tin bài viết, tên user, email user

SELECT users.name AS username, users.email, posts.title, posts.content FROM users
INNER JOIN posts
ON users.id = posts.user_id
INNER JOIN public.group
ON users.group_id = public.group.id
WHERE LOWER(public.group.name) LIKE LOWER('%admin') AND users.status = true

-- Sắp xếp ORDER BY (ASC, DESC): nhiều trường cách nhau dấu ,
SELECT * FROM posts ORDER BY created_at DESC, id ASC;

-- Giới hạn: LIMIT, OFFSET (bỏ bản ghi đầu) -> dùng để phân trang
SELECT * FROM posts ORDER BY created_at DESC, id ASC LIMIT 2  OFFSET 1;

-- 





