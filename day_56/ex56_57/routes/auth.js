var express = require("express");
var router = express.Router();
const authController = require("../controllers/auth.controller");
router.get("/dang-nhap", authController.login);
router.post("/dang-nhap", authController.handleLogin);

router.get("/dang-ky", authController.register);
router.post("/dang-ky", authController.handleRegister);

router.get("/dang-xuat", authController.logout);

module.exports = router;
