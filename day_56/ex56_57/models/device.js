"use strict";
const { Model } = require("sequelize");
module.exports = (sequelize, DataTypes) => {
  class Device extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      Device.belongsTo(models.User, {
        foreignKey: "user_id",
        as: "device",
      });
    }
  }
  Device.init(
    {
      // khai báo các cột trong table
      id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
      },
      user_id: {
        type: DataTypes.INTEGER,
      },
      os_name: {
        type: DataTypes.STRING(100),
      },
      client_type: {
        type: DataTypes.STRING(100),
      },
      client_family: {
        type: DataTypes.STRING(100),
      },
      device_type: {
        type: DataTypes.STRING(100),
      },
      user_agent: {
        type: DataTypes.STRING(100),
      },
      login_time: {
        type: DataTypes.STRING(100),
      },
      logout_time: {
        type: DataTypes.STRING(100),
      },
      is_login: {
        type: DataTypes.BOOLEAN,
      },
    },
    {
      sequelize,
      modelName: "Device",
      createdAt: "created_at",
      updatedAt: "updated_at",
      tableName: "user_devices",
    }
  );
  return Device;
};
