module.exports = (req, res, next) => {
  console.log(req.query);
  if (!req.user) {
    return res.redirect("/auth/login");
  }
  next();
};
