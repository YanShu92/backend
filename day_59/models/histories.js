"use strict";
const { Model } = require("sequelize");
module.exports = (sequelize, DataTypes) => {
  class History extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
    }
  }
  History.init(
    {
      // khai báo các cột trong table
      id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
      },
      recipient: {
        type: DataTypes.STRING(100),
      },
      subject: {
        type: DataTypes.STRING(100),
      },
      message: {
        type: DataTypes.STRING(100),
      },
      status: {
        type: DataTypes.BOOLEAN,
      },
    },
    {
      sequelize,
      modelName: "History",
      createdAt: "created_at",
      updatedAt: "updated_at",
      tableName: "histories",
    }
  );
  return History;
};
