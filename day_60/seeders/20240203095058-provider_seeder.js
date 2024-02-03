"use strict";

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    const data = [
      {
        name: "local",
        created_at: new Date(),
        updated_at: new Date(),
      },
      {
        name: "google",
        created_at: new Date(),
        updated_at: new Date(),
      },
    ];
    await queryInterface.bulkInsert("providers", data);
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.bulkDelete("providers");
  },
};
