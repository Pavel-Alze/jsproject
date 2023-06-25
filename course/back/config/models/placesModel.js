const { Sequelize, DataTypes, Model } = require("sequelize");
const { sequelize } = require("../db");
class Places extends Sequelize.Model {};

Places.init(
    {
      id: {
        type: DataTypes.INTEGER,
        autoIncrement: true,
        primaryKey: true
      },
      title: {
        type: DataTypes.STRING,
      },
      description: {
        type: DataTypes.STRING,
      },
      pointlan:{
        type: DataTypes.DOUBLE,
      },
      pointlon:{
        type: DataTypes.DOUBLE,
      },
    },
    {
      sequelize: sequelize,
      timestamps: false,
      createdAt: false,
      underscored: true,
      modelName: "Places",
    }
  );
  module.exports = Places;