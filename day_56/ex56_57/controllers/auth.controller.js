// const
const { User, Device } = require("../models/index");
const { string } = require("yup");
const bcrypt = require("bcrypt");
const DeviceDetector = require("node-device-detector");
const ClientHints = require("node-device-detector/client-hints");

module.exports = {
  login: async (req, res) => {
    const msg = req.flash("msg");
    const msgLogout = req.flash("msgLogout");
    const msgRegister = req.flash("registerSuccess");
    res.render("auth/login", { req, msg, msgLogout, msgRegister });
  },
  handleLogin: async (req, res) => {
    try {
      const body = await req.validate(req.body, {
        email: string()
          .required("Email bắt buộc phải nhập")
          .email("Email không đúng định dạng"),
        password: string().required("Password bắt buộc phải nhập"),
      });
      if (body) {
        const user = await User.findOne({
          where: {
            email: body.email,
          },
        });
        const isUser = bcrypt.compareSync(body.password, user.password);

        if (!user || !isUser) {
          req.flash("msg", "Email hoặc mật khẩu không chính xác");
          req.flash("old", req.body);
          return res.redirect("/auth/dang-nhap");
        }

        if (user.status !== 1) {
          req.flash("msg", "Bạn cần được cấp quyền mới được truy cập");
          req.flash("old", req.body);
          return res.redirect("/auth/dang-nhap");
        }

        //detect device đăng nhập:
        // 1. option tạo 1 object detector
        const detector = new DeviceDetector({
          clientIndexes: true,
          deviceIndexes: true,
          deviceAliasCode: false,
        });
        const clientHints = new ClientHints();
        // 2. getter client from server
        const userAgent = req.headers["user-agent"];
        const clientHintsData = clientHints.parse(req.headers);
        // 3. detect user agent vào object
        const result = detector.detect(userAgent);
        console.log("result:", result);
        // console.log("clientHint:", clientHintsData);
        // result
        // {
        //   os: {
        //     name: 'Windows',
        //     short_name: 'WIN',
        //     version: '10',
        //     platform: 'x64',
        //     family: 'Windows'
        //   },
        //   client: {
        //     type: 'browser',
        //     name: 'Chrome',
        //     short_name: 'CH',
        //     version: '120.0.0.0',
        //     engine: 'Blink',
        //     engine_version: '120.0.0.0',
        //     family: 'Chrome'
        //   },
        //   device: { id: '', type: 'desktop', brand: '', model: '' }
        // }

        // 4. nhập dữ liệu vào bảng user_device
        // Mindset: thiết bị đăng nhập -> đưa vào bảng
        // đã tồn tại thì cập nhật lại thời gian login
        // 4.1 kiểm tra user đã đăng nhập trên thiết bị này chưa
        const checkDevice = await Device.findOne({
          where: {
            user_id: user.id,
            user_agent: userAgent,
          },
        });
        console.log(checkDevice);
        // 4.2 Đã tồn tại thì update, chưa thì thêm vào bảng
        if (checkDevice) {
          await Device.update(
            {
              login_time: "now()",
              is_login: true,
            },
            {
              where: {
                user_id: user.id,
                user_agent: userAgent,
              },
            }
          );
        } else {
          await Device.create({
            user_id: user.id,
            os_name: result.os.name,
            client_type: result.client.type,
            client_family: result.client.family,
            device_type: result.device.type,
            user_agent: userAgent,
            is_login: true,
          });
        }

        // req session đăng nhập
        req.session.User = {
          name: user.name,
          id: user.id,
          email: user.email,
          status: "success",
          isLogin: true,
        };
        req.session.authorized = true;
        return res.redirect("/");
      }
      res.redirect("/auth/dang-nhap");
    } catch (e) {
      console.log(e);
    }
  },

  register: (req, res) => {
    const msg = req.flash("msg");
    console.log(req.errors);
    return res.render("auth/register", { req, msg });
  },

  handleRegister: async (req, res) => {
    try {
      const body = await req.validate(req.body, {
        name: string().required("Tên bắt buộc phải nhập"),
        email: string()
          .required("Email bắt buộc phải nhập")
          .email("Email không đúng định dạng")
          .test("check-unique", "Email đã tồn tại", async (value) => {
            //true -> pass
            //false -> fail
            const result = await User.findOne({
              where: {
                email: value,
              },
            });
            console.log(result);
            return !result;
          }),
        password: string().required("Password bắt buộc phải nhập"),
        reenterPassword: string()
          .required("Nhập lại password")
          .test("check-password", "Password nhập lại không khớp", (value) => {
            return value === req.body.password;
          }),
      });
      if (body) {
        const password = bcrypt.hashSync(body.password, 10);

        await User.create({
          name: body.name,
          email: body.email,
          password,
          status: 0,
        });
        req.flash("registerSuccess", "Bạn đã đăng ký thành công");
        return res.redirect("/auth/dang-nhap");
      }
      req.flash("msg", "Có lỗi xảy ra, đăng kí thất bại!");
      res.redirect("/auth/dang-ky");
    } catch (e) {
      console.log(e);
    }
  },

  logout: async (req, res) => {
    delete req.session.authorized;
    delete req.session.User;
    const userAgent = req.headers["user-agent"];
    // update time logout device
    await Device.update(
      {
        logout_time: "now()",
        is_login: false,
      },
      {
        where: {
          user_agent: userAgent,
        },
      }
    );
    req.flash("msgLogout", "Đăng xuất thành công");
    // Becare: destroy thì mất flash
    // destroy phải để sau flash nếu không fail
    // req.session.destroy();
    return res.redirect("/auth/dang-nhap");
  },

  logoutOneDevice: async (req, res) => {
    const { id } = req.params;
    console.log(id);
    await Device.update(
      {
        logout_time: "now()",
        is_login: false,
      },
      {
        where: {
          id: id,
        },
      }
    );

    // check thiết bị
    const userAgent = req.headers["user-agent"];
    const checkDevice = await Device.findOne({
      where: {
        id: id,
        user_agent: userAgent,
      },
    });
    console.log(checkDevice);
    if (checkDevice) {
      return res.redirect("/auth/dang-nhap");
    }
    return res.redirect("/auth/manage-device");
  },
};
