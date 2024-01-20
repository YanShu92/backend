const userModel = require("../models/user");
const { string } = require("yup");
module.exports = {
  index: async (req, res, next) => {
    try {
      const { status, keyword } = req.query;

      const users = await userModel.all(status, keyword);
      const msg = req.flash("msg");
      res.render("users/index", { users, msg });
    } catch (e) {
      return next(e);
    }
  },
  add: (req, res) => {
    res.render("users/add", { req });
  },
  handleAdd: async (req, res) => {
    try {
      console.log(req.body);
      const body = await req.validate(req.body, {
        name: string().required("tên bắt buộc phải nhập"),
        email: string()
          .required("email bắt buộc phải nhập")
          .email("email không đúng định dạng")
          .test("check-unique", "Email đã tồn tại", async (value) => {
            //true -> pass
            //false -> fail
            const result = await userModel.emailExist(value);
            return !result.length;
          }),
        status: string().test(
          "check-status",
          "trạng thái không hợp lệ",
          (value) => {
            if (value === "0" || value === "1") {
              return true;
            }
            return false;
          }
        ),
      });
      if (body) {
        body.status = body.status === "1" ? true : false;
        await userModel.create(body);
        req.flash("msg", "Thêm người dùng thành công");
        return res.redirect("/users");
      }
      res.redirect("/users/add");
    } catch (e) {
      console.log(e);
    }
  },

  edit: async (req, res, next) => {
    const { id } = req.params;
    try {
      const user = await userModel.find(id);
      if (!user.length) {
        // ERRor handler
        throw new Error("User không tồn tại");
      }
      user[0].status = user[0].status ? "1" : "0";
      req.old = user[0];
      const msg = req.flash("msg");
      res.render("users/edit", { req, msg });
    } catch (e) {
      return next(e);
    }
  },
  handleEdit: async (req, res) => {
    const { id } = req.params;
    const body = await req.validate(req.body, {
      name: string().required("tên bắt buộc phải nhập"),
      email: string()
        .required("email bắt buộc phải nhập")
        .email("email không đúng định dạng")
        .test("check-unique", "Email đã tồn tại", async (value) => {
          //true -> pass
          //false -> fail
          const result = await userModel.emailExist(value);
          return !result.length;
        }),
      status: string().test(
        "check-status",
        "trạng thái không hợp lệ",
        (value) => {
          if (value === "0" || value === "1") {
            return true;
          }
          return false;
        }
      ),
    });
    if (body) {
      body.status = body.status === "1" ? true : false;
      await userModel.update(body, id);
      req.flash("msg", "cập nhật thành công");
    }
    return res.redirect("/users/edit/" + id);
  },

  delete: async (req, res) => {
    const { id } = req.params;
    await userModel.delete(id);
    req.flash("msg", "Xóa ng dùng thành công");
    res.redirect("/users");
  },
};
