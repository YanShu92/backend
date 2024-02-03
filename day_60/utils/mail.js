"use strict";
const nodemailer = require("nodemailer");

const transporter = nodemailer.createTransport({
  host: "smtp.gmail.com",
  port: 465, //587, 25
  secure: true,
  auth: {
    // TODO: replace `user` and `pass` values from <https://forwardemail.net>
    user: "thanhvilang@gmail.com",
    pass: "oraw rwsk viik rnct",
  },
});

module.exports = async (to, subject, message) => {
  const info = await transporter.sendMail({
    from: '"Thanh F8K4👻" <thanhvilang@gmail.com>', // sender address
    to,
    subject, // Subject line
    text: "Bạn nhận mail từ Thanh K4",
    html: message, // html body
  });
  return info;
};
