require("dotenv").config();

var createError = require("http-errors");
var express = require("express");
var path = require("path");
var cookieParser = require("cookie-parser");
var logger = require("morgan");

const expressEjsLayout = require("express-ejs-layouts");
const session = require("express-session");
const flash = require("connect-flash");
const passport = require("passport");
const passportLocal = require("./passports/passport.local");
const passportGoogle = require("./passports/passport.google");

var indexRouter = require("./routes/index");
var usersRouter = require("./routes/users");
var authRouter = require("./routes/auth");
const resetPasswordRouter = require("./routes/resetPassword");
const { User } = require("./models/index");

const validateMiddleware = require("./middlewares/validate.middleware");
const authMiddleware = require("./middlewares/auth.middleware");
const { request } = require("http");

var app = express();
app.use(
  session({
    secret: "f8",
    resave: false,
    saveUninitialized: true,
  })
);

app.use(flash());
app.use(passport.initialize());
app.use(passport.session());
passport.use("local", passportLocal);
passport.use("google", passportGoogle);

passport.serializeUser(function (user, done) {
  done(null, user.id); // lưu user vào session
});

passport.deserializeUser(async function (id, done) {
  const user = await User.findByPk(id); // truy vấn database trả về user
  done(null, user);
});
// view engine setup
app.set("views", path.join(__dirname, "views"));
app.set("view engine", "ejs");
app.use(expressEjsLayout);

app.use(logger("dev"));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, "public")));

app.use(validateMiddleware);

app.use("/auth", authRouter);
app.use("/reset_password", resetPasswordRouter);
app.use(authMiddleware);

app.use("/", indexRouter);
app.use("/users", usersRouter);

// catch 404 and forward to error handler
app.use(function (req, res, next) {
  next(createError(404));
});

// error handler
app.use(function (err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get("env") === "development" ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render("error");
});

module.exports = app;
