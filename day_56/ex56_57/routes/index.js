var express = require("express");
var router = express.Router();

const homeController = require("../controllers/home.controller");
/* GET home page. */
router.get("/", homeController.index);
router.get("/update-profile", homeController.update);
router.post("/update-profile", homeController.handleUpdate);

router.get("/change-password", homeController.changePassword);
router.post("/change-password", homeController.handleChangePassword);

module.exports = router;
