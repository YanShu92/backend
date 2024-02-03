"use strict";
const bcrypt = require("bcrypt");
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    const data = [
      {
        name: "Hoàng Thanh",
        email: "thanhvilang@gmail.com",
        password: bcrypt.hashSync("123456", 10),
        provider_id: 1,
        created_at: new Date(),
        updated_at: new Date(),
      },
      {
        name: "admin",
        email: "admin@gmail.com",
        password: bcrypt.hashSync("123456", 10),
        provider_id: 1,
        created_at: new Date(),
        updated_at: new Date(),
      },
    ];
    await queryInterface.bulkInsert("users", data);
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.bulkDelete("users");
  },
};
