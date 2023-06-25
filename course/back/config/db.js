const { Sequelize } = require("sequelize");
require("dotenv/config");
const sequelize = new Sequelize(process.env.DATA_BASE_NAME, process.env.DATA_BASE_USER, process.env.PASSWORD, {
  host: process.env.DATA_BASE_HOST,
  dialect: process.env.DATA_BASE_DIALECT,
  port: process.env.DATA_BASE_PORT,
});

const initDB = async () => {
  try {
    await sequelize.authenticate();
    await sequelize.createSchema('public', {});
    await sequelize.sync();
    console.log("Соединение с БД было успешно установлено");
  } catch (e) {
    console.log("Невозможно выполнить подключение к БД: ", e);
  }
};

module.exports = { sequelize, initDB };
