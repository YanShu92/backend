var express = require("express");
var router = express.Router();
const authController = require("../controllers/auth.controller");
router.get("/dang-nhap", authController.login);
router.get("/dang-xuat", authController.logout);
router.post("/dang-nhap", authController.handleLogin);

module.exports = router;
