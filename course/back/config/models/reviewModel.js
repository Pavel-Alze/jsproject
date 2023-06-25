const { Sequelize, DataTypes, Model } = require("sequelize");
const { sequelize } = require("../db");
class Review extends Sequelize.Model {};

Review.init(
    {
      id: {
        type: DataTypes.INTEGER,
        autoIncrement: true,
        primaryKey: true,
      },
      title: {
        type: DataTypes.STRING,
      },
      user_id: {
        type: DataTypes.INTEGER,
      },
      place_id: {
        type: DataTypes.INTEGER,
      },
      description: {
        type: DataTypes.STRING,
      },
    },
    {
      sequelize: sequelize,
      timestamps: false,
      createdAt: false,
      underscored: true,
      modelName: "Review",
    }
  );
  module.exports = Review;