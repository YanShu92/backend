const sendMail = require("../utils/mail");
const { string } = require("yup");
const { History } = require("../models/index");

module.exports = {
  index: (req, res) => {
    const sendSuccess = req.flash("sendSuccess");
    const msgFail = req.flash("msgFail");
    console.log("error", req.errors);
    res.render("mail/index", { req, sendSuccess, msgFail });
  },
  handleSend: async (req, res, next) => {
    try {
      const body = await req.validate(req.body, {
        recipient: string()
          .required("Email bắt buộc phải nhập")
          .email("Email không đúng định dạng"),
        subject: string().required("Tiêu đề bắt buộc phải nhập"),
        message: string().required("Nội dung bắt buộc phải nhập"),
      });
      if (body) {
        const { recipient, subject, message } = req.body;
        const info = await sendMail(recipient, subject, message);

        await History.create({
          recipient,
          subject,
          message,
          create_at: new Date(),
        });

        req.flash("sendSuccess", "Bạn đã tin nhắn gửi thành công");
        return res.redirect("/mail");
      }
    } catch (e) {
      return next(e);
    }
    return res.redirect("/mail");
  },
  histories: async (req, res, next) => {
    let histories = await History.findAll();
    histories = histories.map((history) => history.dataValues);
    // histories.map((history, index) => {
    //   document
    //     .querySelector(`.btn_check${index}`)
    //     .addEventListener("click", () => {
    //       console.log(1111);
    //     });
    // });
    res.render("mail/histories", { histories, req });
  },
};
