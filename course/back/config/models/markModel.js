const { Sequelize, DataTypes, Model } = require("sequelize");
const { sequelize } = require("../db");
class Mark extends Sequelize.Model {};

Mark.init(
    {
      user_id: {
        type: DataTypes.INTEGER,
        primaryKey: true
      },
      place_id: {
        type: DataTypes.INTEGER,
        primaryKey: true
      },
      label: {
        type: DataTypes.STRING,
      }
    },
    {
      sequelize: sequelize,
      timestamps: false,
      createdAt: false,
      underscored: true,
      modelName: "marks",
    }
  );
  module.exports = Mark;