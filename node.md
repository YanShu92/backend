# cài các gói (buổi 60)

npm i -g express-generator
express --view=ejs
npm i
npm i dotenv express-session connect-flash express-ejs-layouts yup postgres

-> sau đó sửa pagekage.json -> nodemon

# thêm controller -> router thêm vào

# thiết lập layout

## vào app thêm dòng đầu tiên

require("dotenv").config();

thêm:
const expressEjsLayout = require("express-ejs-layout");
app.use(expressEjsLayout); // sau app.set

# thêm middlewares

thêm file js

gọi middleware vào app, để trc router

const validateMiddleware = require("./middlewares/validate.middleware");

app.use(validateMiddleware);

## theem session va flash vao app

const session = require("express-session");
const flash = require("connect-flash");

app.use(
session({
secret: "f8",
resave: false,
saveUninitialized: true,
})
);

app.use(flash());

# cai sequelize

npm install --save sequelize
npm install --save pg pg-hstore // driver pg

## cai them cli

npm install --save-dev sequelize-cli

## khoi tao ket noi: config, models, migrations, seeders

npx sequelize-cli init

# them env

- sua config -> .js
- them .sequelizerc
- sua models/index

# tạo database sd migrations(cấu trúc bảng)

// tạo ở pgadmin
npx sequelize db:create

# tạo bảng bằng migration

npx sequelize migration:generate -name=create_users_table

npx sequelize-cli db:migrate

# seeder

npx sequelize-cli seed:generate --name=provider_seeder

npx sequelize-cli db:seed:all
