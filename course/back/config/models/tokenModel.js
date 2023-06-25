const { Sequelize, DataTypes, Model } = require("sequelize");
const { sequelize } = require("../db");
class Token extends Sequelize.Model {};

Token.init(
    {
      id: {
        type: DataTypes.INTEGER,
        autoIncrement: true,
        primaryKey: true,
      },
      token: {
        type: DataTypes.STRING,
      },
      login_id: {
        type: DataTypes.INTEGER,
      },
      user_id: {
        type: DataTypes.INTEGER,
      },
    },
    {
      sequelize: sequelize,
      timestamps: false,
      createdAt: false,
      underscored: true,
      modelName: "Token",
    }
  );
  module.exports = Token;