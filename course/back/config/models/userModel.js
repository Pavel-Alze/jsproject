const { Sequelize, DataTypes, Model } = require("sequelize");
const { sequelize } = require("../db");
class User extends Sequelize.Model {};
User.init(
    {
      id: {
        type: DataTypes.INTEGER,
        autoIncrement: true,
        primaryKey: true,
      },
      name: {
        type: DataTypes.STRING,
      },
      surname: {
        type: DataTypes.STRING,
      },
      phone: {
        type: DataTypes.STRING,
      },
      email: {
        type: DataTypes.STRING,
      },
      age: {
        type: DataTypes.INTEGER,
      },
      login_id: {
        type: DataTypes.INTEGER,
      },
    },
    {
      sequelize: sequelize,
      timestamps: false,
      createdAt: false,
      underscored: true,
      modelName: "User",
    }
  );
  module.exports = User;  