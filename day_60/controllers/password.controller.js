const moment = require("moment/moment");
const { User } = require("../models/index");
const bcrypt = require("bcrypt");
const sendMail = require("../utils/mail");

module.exports = {
  resetPassword: async (req, res, next) => {
    const msgFail = req.flash("msgFail");
    const msg = req.flash("msg");

    const { token } = req.query;
    const isExistUser = await User.findOne({
      where: {
        reset_token: token,
      },
    });
    if (!isExistUser) {
      return res.render("password/noUser");
    }
    const { dataValues: user } = isExistUser;
    const isExpired = user.expired_token.getTime() > new Date().getTime();
    if (!isExpired) {
      return res.render("password/tokenExpire");
    }
    res.render("password/reset", { user, msgFail, msg });
  },
  handleResetPassword: async (req, res, next) => {
    const { token } = req.query;
    const { newPassword, reenterNewPassword } = req.body;
    if (newPassword !== reenterNewPassword) {
      req.flash("msgFail", "Hai mật khẩu không khớp, vui lòng nhập lại");
      return res.redirect(`/reset_password?token=${token}`);
    }

    const isExistUser = await User.findOne({
      where: {
        reset_token: token,
      },
    });
    const { dataValues: user } = isExistUser;
    await User.update(
      {
        reset_token: null,
        password: bcrypt.hashSync(newPassword, 10),
      },
      {
        where: {
          email: user.email,
        },
      }
    );
    const info = await sendMail(
      user.email,
      "Reset mật khẩu thành công",
      "<p>Bạn đã đổi mật khẩu thành công</p>"
    );
    req.flash(
      "msg",
      "Bạn đổi mật khẩu thành công! Về trang đăng nhập để trải nghiệm"
    );

    return res.redirect(`/reset_password/success`);
  },
  resetPasswordSuccess: async (req, res, next) => {
    const msg = req.flash("msg");
    res.render("password/successReset", { msg });
  },
};
