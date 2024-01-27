const { User, Device } = require("../models/index");
const { Op } = require("sequelize");
const { string } = require("yup");
const bcrypt = require("bcrypt");

module.exports = {
  index: async (req, res, next) => {
    const userAgent = req.headers["user-agent"];
    // const checkDevice = await Device.findOne({
    //   where: {
    //     user_id: req.session.User.id,
    //     user_agent: userAgent,
    //   },
    // });

    if (!req.session.authorized) {
      return res.redirect("/auth/dang-nhap");
    }
    res.render("home/index", { req });
  },

  update: (req, res, next) => {
    const msg = req.flash("msg");
    const msgFail = req.flash("msgFail");
    res.render("home/updateProfile", { req, msg, msgFail });
  },

  handleUpdate: async (req, res, next) => {
    const body = req.body;
    const bodyValidate = await req.validate(body, {
      name: string().required("Name không được để trống"),
      email: string()
        .required("Email bắt buộc phải nhập")
        .email("Email không đúng định dạng"),
    });
    if (bodyValidate) {
      try {
        const isExistEmail = await User.findOne({
          where: {
            email: body.email,
            id: {
              [Op.not]: req.session.User.id,
            },
          },
        });
        if (isExistEmail) {
          req.flash("msgFail", "Email đã tồn tại");
          return res.redirect("/update-profile");
        }
        const status = await User.update(
          {
            name: body.name,
            email: body.email,
          },
          {
            where: { id: req.session.User.id },
          }
        );
        req.session.User = {
          name: body.name,
          email: body.email,
        };
        req.flash("msg", "Cập nhật profile thành công");
      } catch (e) {
        return next(e);
      }
    }
    return res.redirect("/update-profile");
  },

  changePassword: (req, res, next) => {
    const msg = req.flash("msg");
    const msgFail = req.flash("msgFail");
    console.log(msgFail);
    res.render("home/changePassword", { req, msg, msgFail });
  },

  handleChangePassword: async (req, res, next) => {
    const body = req.body;
    const bodyValidate = await req.validate(body, {
      oldPassword: string().required("Nhập mật khẩu cũ"),
      newPassword: string().required("Nhập mật khẩu mới"),
      reenterPassword: string().required("Nhập lại mật khẩu mới"),
    });
    console.log(bodyValidate);
    if (bodyValidate) {
      try {
        const { dataValues: user } = await User.findOne({
          where: { id: req.session.User.id },
        });
        console.log(bodyValidate.oldPassword, user.password);
        const checkPassword = await bcrypt.compare(
          body.oldPassword,
          user.password
        );
        console.log(checkPassword);
        if (!checkPassword) {
          req.flash("msgFail", "Mật khẩu cũ không chính xác");
          return res.redirect("/change-password");
        }

        if (bodyValidate.newPassword !== bodyValidate.reenterPassword) {
          req.flash("msgFail", "Mật khẩu mới không khớp");
          return res.redirect("/change-password");
        }

        if (bodyValidate.newPassword === bodyValidate.oldPassword) {
          req.flash("msgFail", "Mật khẩu mới nên khác mật khẩu cũ");
          return res.redirect("/change-password");
        }
        console.log(bodyValidate.newPassword);
        const status = await User.update(
          {
            password: await bcrypt.hash(bodyValidate.newPassword, 10),
          },
          {
            where: { id: req.session.User.id },
          }
        );
        req.flash("msg", "Đổi mật khẩu thành công");
        return res.redirect("/dang-xuat");
      } catch (e) {
        return next(e);
      }
    }
    return res.redirect("/change-password");
  },

  manageDevice: async (req, res, next) => {
    let devices = await Device.findAll({
      where: {
        user_id: req.session.User.id,
      },
    });
    devices = devices.map((device) => device.dataValues);
    console.log(devices);
    res.render("home/manageDevice", { req, devices });
  },
};
