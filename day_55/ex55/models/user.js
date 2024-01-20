//Tư duy model:
//- Mỗi model sẽ tương ứng với 1 table
//- 1 controller có thể có nhiều model
const sql = require("../utils/db");
module.exports = {
  all: (status, keyword) => {
    console.log(keyword);
    let filter = sql`WHERE name IS NOT NULL`;
    if (status === "active" || status === "inactive") {
      filter = sql`${filter} AND status=${status === "active" ? true : false}`;
    }
    if (keyword) {
      filter = sql`${filter} AND (name ILIKE ${
        "%" + keyword + "%"
      } OR email ILIKE ${"%" + keyword + "%"})`;
    }
    return sql`SELECT * FROM users ${filter} ORDER BY id DESC`;
  },

  emailExist: (email, id = 0) => {
    const ignore = id > 0 ? sql`WHERE id != ${id}` : sql``;
    return sql`SELECT id FROM users WHERE email=${email} ${ignore}`;
  },

  create: ({ name, email, status }) => {
    return sql`INSERT INTO users(name, email, status, created_at, updated_at) VALUES(${name}, ${email}, ${status}, NOW(), NOW())`;
  },

  find: (id) => {
    return sql`SELECT * FROM users WHERE id = ${id}`;
  },

  update: ({ name, email, status }, id) => {
    return sql`UPDATE users SET name = ${name}, email=${email}, status =${status} WHERE id = ${id}`;
  },

  delete: (id) => {
    return sql`DELETE FROM users WHERE id = ${id}`;
  },
};

/*
1. Không lọc
SELECT * FROM users ORDER BY id DESC

2. Lọc status
SELECT * FROM users WHERE status=${status} ORDER BY id DESC

3. Lọc keyword
SELECT * FROM users WHERE name LIKE '%keyword%' OR email LIKE '%keyword%' ORDER BY id DESC

4. Lọc cả status và keyword
SELECT * FROM users WHERE status=${status} AND  (name LIKE '%keyword%' OR email LIKE '%keyword%') ORDER BY id DESC
*/
