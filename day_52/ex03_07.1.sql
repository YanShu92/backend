-- Hàm tổng hợp: COUNT(đếm số dòng), SUM, AVG, MAX, MIN
-- KHi dùng các hàm tổng hợp phải kết hợp với mệnh đề GROUP BY
-- Lọc dữ liệu theo mệnh đề GROUP BY -> mệnh đề HAVING
-- WHERE phải trước group
-- SELECT -> FROM -> JOIN -->ON --> WHERE --> GROUP --> HAVING--> ORDER --> LIMIT
-- HAVING ko được đổi biến, chỉ nhận biểu thức
SELECT status, count(id) FROM users GROUP BY status
HAVING count(id) > 2 ;

-- C1: Hiển thị d/s user và số lượng bài viết từng user 
-- nếu user ko có bài viết thì hiện 0
SELECT users.*, count(posts.user_id) AS post_count FROM users
LEFT JOIN posts
ON users.id = posts.user_id
GROUP BY users.id;

-- C2: Sx thứ tự hiển thị theo sl bài viết giảm dần
SELECT users.*, count(posts.user_id) AS post_count FROM users
LEFT JOIN posts
ON users.id = posts.user_id
GROUP BY users.id
ORDER BY post_count DESC;

-- C3: Hiển thị user có số bài viết lớn nhất
SELECT users.*, count(posts.user_id) AS post_count FROM users
LEFT JOIN posts
ON users.id = posts.user_id
GROUP BY users.id
HAVING COUNT(posts.user_id) = (
	-- Dùng MAX phải cần 1 cột
	SELECT MAX(posts_count) 
	FROM (
		-- Bảng tạm
		SELECT count(id) AS posts_count 
		FROM posts 
		GROUP BY user_id
	)
)




