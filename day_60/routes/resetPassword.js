var express = require("express");
var router = express.Router();
const resetPasswordController = require("../controllers/password.controller");
/* GET home page. */
router.get("/", resetPasswordController.resetPassword);
router.post("/", resetPasswordController.handleResetPassword);

router.get("/success", resetPasswordController.resetPasswordSuccess);

module.exports = router;
