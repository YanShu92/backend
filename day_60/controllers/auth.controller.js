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

    res.render("auth/login", { error });
  },
  forgotPassword: (req, res) => {
    const msgFail = req.flash("msgFail");
    const msg = req.flash("msg");
    // console.log("host", req.get("host"));
    res.render("password/forgot", { msgFail, msg, req });
  },
  handleForgotPassword: async (req, res) => {
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
