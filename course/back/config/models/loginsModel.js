const { Sequelize, DataTypes, Model } = require("sequelize");
const { sequelize } = require("../db");

class Logins extends Sequelize.Model {};




Logins.init(
  {
    id: {
      type: DataTypes.INTEGER,
      autoIncrement: true,
      primaryKey: true,
    },
    login: {
      type: DataTypes.STRING,
    },
    password: {
      type: DataTypes.STRING,
    },
  },
  {
    sequelize: sequelize,
    timestamps: false,
    createdAt: false,
    underscored: true,
    modelName: "Logins",
  }
);

module.exports = Logins;
