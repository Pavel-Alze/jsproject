const { Sequelize, DataTypes, Model } = require("sequelize");
const { sequelize } = require("../db");

class Eas extends Sequelize.Model {};

Eas.init(
  {
    id: {
      type: DataTypes.INTEGER,
      autoIncrement: true,
      primaryKey: true,
    },
    pass: {
      type: DataTypes.STRING,
    },

  },
  {
    sequelize: sequelize,
    timestamps: false,
    createdAt: false,
    underscored: true,
    modelName: "easypases",
  }
);

module.exports = Eas;
