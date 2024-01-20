module.exports = {
  index: (req, res, next) => {
    if (!req.session.authorized) {
      return res.redirect("/auth/dang-nhap");
    }
    res.render("home/index");
  },
};
