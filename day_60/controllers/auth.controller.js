// const
const { User } = require("../models/index");
const { string } = require("yup");
const bcrypt = require("bcrypt");
const sendMail = require("../utils/mail");
const md5 = require("md5");
const moment = require("moment/moment");
module.exports = {
  login: async (req, res) => {
    if (req.user) {
      return res.redirect("/");
    }
    const error = req.flash("error");
    const msgRegister = req.flash("registerSuccess");

    res.render("auth/login", { error, msgRegister });
  },
  register: (req, res) => {
    const msg = req.flash("msg");
    console.log(req.errors);
    return res.render("auth/register", { req, msg });
  },

  handleRegister: async (req, res) => {
    try {
      const body = await req.validate(req.body, {
        name: string().required("Tên bắt buộc phải nhập"),
        email: string()
          .required("Email bắt buộc phải nhập")
          .email("Email không đúng định dạng")
          .test("check-unique", "Email đã tồn tại", async (value) => {
            //true -> pass
            //false -> fail
            const result = await User.findOne({
              where: {
                email: value,
                provider_id: 1,
              },
            });
            console.log(result);
            return !result;
          }),
        password: string().required("Password bắt buộc phải nhập"),
        reenterPassword: string()
          .required("Nhập lại password")
          .test("check-password", "Password nhập lại không khớp", (value) => {
            return value === req.body.password;
          }),
      });
      if (body) {
        const password = bcrypt.hashSync(body.password, 10);

        await User.create({
          name: body.name,
          email: body.email,
          password,
          provider_id: 1,
        });
        req.flash("registerSuccess", "Bạn đã đăng ký thành công");
        return res.redirect("/auth/login");
      }
      req.flash("msg", "Có lỗi xảy ra, đăng kí thất bại!");
      res.redirect("/auth/register");
    } catch (e) {
      console.log(e);
    }
  },
  forgotPassword: (req, res) => {
    const msgFail = req.flash("msgFail");
    const msg = req.flash("msg");
    // console.log("host", req.get("host"));
    res.render("password/forgot", { msgFail, msg, req });
  },
  handleForgotPassword: async (req, res, next) => {
    const body = req.body;
    const bodyValidate = await req.validate(body, {
      email: string()
        .required("Email bắt buộc phải nhập")
        .email("Email không đúng định dạng"),
    });
    console.log("bodyValidate", bodyValidate);
    if (bodyValidate) {
      try {
        const isExistEmail = await User.findOne({
          where: {
            email: body.email,
          },
        });
        if (!isExistEmail) {
          req.flash(
            "msgFail",
            "Email chưa đăng kí! Vui lòng đăng kí tài khoản"
          );
          return res.redirect("/auth/forgot-password");
        }
        const resetToken = md5(Math.random() + new Date().getTime());
        await User.update(
          {
            expired_token: moment().add(15, "minutes").format(),
            reset_token: resetToken,
          },
          {
            where: {
              email: body.email,
            },
          }
        );
        const host = req.get("host");
        const info = await sendMail(
          body.email,
          "Đổi lại mật khẩu",
          "<p>Bạn nhận được link lấy lại mật khẩu từ F8</p><p>Nếu là bạn, click link sau lấy lại mật khẩu, nếu không bỏ qua tin nhắn này</p>" +
            `http://${host}/reset_password?token=${resetToken}`
        );
        req.flash("msg", "Bạn gửi email lấy lại mật khẩu thành công");
      } catch (e) {
        return next(e);
      }
    }
    return res.redirect("/auth/forgot-password");
  },
};
