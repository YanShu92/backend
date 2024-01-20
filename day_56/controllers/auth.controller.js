// const
const { User } = require("../models/index");
const { string } = require("yup");
const bcrypt = require("bcrypt");

module.exports = {
  login: async (req, res) => {
    const msg = req.flash("msg");
    const msgLogout = req.flash("msgLogout");
    res.render("auth/login", { req, msg, msgLogout });
  },
  handleLogin: async (req, res) => {
    try {
      const body = await req.validate(req.body, {
        email: string()
          .required("Email bắt buộc phải nhập")
          .email("Email không đúng định dạng"),
        password: string().required("Password bắt buộc phải nhập"),
      });
      if (body) {
        const user = await User.findOne({
          where: {
            email: body.email,
          },
        });
        const isUser = bcrypt.compareSync(body.password, user.password);

        if (!user || !isUser) {
          req.flash("msg", "Email hoặc mật khẩu không chính xác");
          req.flash("old", req.body);
          return res.redirect("/auth/dang-nhap");
        }

        req.session.User = {
          name: user.name,
          status: "success",
          isLogin: true,
        };
        req.session.authorized = true;
        return res.redirect("/");
      }
      res.redirect("/auth/dang-nhap");
    } catch (e) {
      console.log(e);
    }
  },
  logout: async (req, res) => {
    delete req.session.authorized;
    delete req.session.User;
    req.flash("msgLogout", "Đăng xuất thành công");
    // destroy thì mất flash
    // destroy phải để sau flash nếu không fail
    // req.session.destroy();
    return res.redirect("/auth/dang-nhap");
  },
};
