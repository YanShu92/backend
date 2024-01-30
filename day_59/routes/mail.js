var express = require("express");
var router = express.Router();
const mailController = require("../controllers/mail.controller");
/* GET users listing. */
router.get("/", mailController.index);
router.post("/", mailController.handleSend);

router.get("/histories", mailController.histories);

module.exports = router;
