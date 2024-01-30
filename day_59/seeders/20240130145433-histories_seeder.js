"use strict";

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    const data = [
      {
        recipient: "tieudiepthanh93@gmail.com",
        subject: "K8 fullstack",
        message: "Hello F8",
        created_at: new Date(),
        updated_at: new Date(),
      },
      {
        recipient: "tieudiepthanh93@gmail.com",
        subject: "K8 fullstack",
        message: "Hello Kitty",
        created_at: new Date(),
        updated_at: new Date(),
      },
    ];
    await queryInterface.bulkInsert("histories", data);
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.bulkDelete("histories");
  },
};
