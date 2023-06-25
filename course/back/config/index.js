const fastify = require("fastify")({ logger: true });
const { initDB, sequelize } = require("./db");
fastify.register(require("@fastify/cors"));
require("dotenv/config");
const { QueryTypes } = require('sequelize');
const { Sequelize, DataTypes, where } = require("sequelize");

const Logins = require("./models/loginsModel");
const User = require("./models/userModel");
const Token = require("./models/tokenModel");
const Places = require("./models/placesModel");
const ReView = require("./models/reviewModel");
const Mark = require("./models/markModel");
const Eas = require("./models/easypassModel");


const bcrypt = require("bcrypt");
const crypto = require("crypto");
const jwt = require('jsonwebtoken');
const { request } = require("http");

const lowReg = "qwertyuiopasdfghjklzxcvbnm"
const highReg = "QWERTYUIOPASDFGHJKLZXCVBNM"
const num = "0123456789"
const spesial = "!@#$%^&*()_+=-`~/|><,.?[]{};:"
async function processLineByLine(string) {
  var isl = false;
  var ish = false;
  var isnum = false;
  var isspe = false;
  if(string.length<8){
    return false
  }
  for (let i = 0; i < string.length; i++) {
    if(lowReg.indexOf(string[i])!=-1){
      isl = true;
    }
    if(highReg.indexOf(string[i])!=-1){
      ish = true;
    }
    if(num.indexOf(string[i])!=-1){
      isnum = true;
    }
    if(spesial.indexOf(string[i])!=-1){
      isspe = true;
    }
  }
  if(!(isl&&ish&&isnum&&isspe)){
    return false
   }

  if(await Eas.findOne({where:{pass:string}})){
    return false
  }
  return true;

}


initDB();


fastify.post("/auth/registration", async (request, reply) => {


  const name = request.body.name;
  const surname = request.body.surname;
  const phone = request.body.phone;
  const email = request.body.email;
  const age = request.body.age;
  const login = request.body.login;
  const password = request.body.password;
 
  try {
    const ifLoginFromBD = await Logins.findOne({
      where: {
        login: login,
      },
    });
    if (ifLoginFromBD) {
      reply.status(401).send({ message: "Login существует" });
      throw new Error("Login существует");
    }

    if(!(await processLineByLine(password))){
      console.log(0)
      reply.send({message:"Нельзя использовать такой пароль"})
      throw new Error("Password bad");
    }else{
    const salt = bcrypt.genSaltSync(10);
    const hashPassword = bcrypt.hashSync(password, salt);
  
    const LoginFromDB = await Logins.create({
      login: login,
      password: hashPassword
    })
    const NewUser = await User.create({
      name: name,
      surname: surname,
      phone: phone,
      email: email,
      age: age,
      login_id: LoginFromDB.id,
    });
    const token = jwt.sign({ login: login, time: new Date() }, process.env.JWT_SECRET);
    await Token.create({
      token: token,
      login_id: LoginFromDB.id,
      user_id: NewUser.id,
    });

    reply.status(200).send({token});
  }
  } catch (error) {
    reply.status(500).send({ error: error.message });
}
});


fastify.post("/auth/login", async (request, reply) => {


  const login = request.body.login;
  const password = request.body.password;
  try {
    const loginFromDB = await Logins.findOne({
      where: {
        login: login,
      },
    });
    if (!loginFromDB) {
      reply.status(404).send({ message: "User not Found" });
      throw new Error("User not Found");
    }
    const ispass = bcrypt.compareSync(password, loginFromDB.password);
    if (!ispass) {
      reply.status(403).send({ message: "Password Incorect" });
      throw new Error("Password Incorect");
    }
    const token = jwt.sign({ login: login, time: new Date() }, process.env.JWT_SECRET);

    const tryToken = await Token.findOne({
      where: {
        login_id: loginFromDB.id,
      },
    })
    if(tryToken){
      await tryToken.destroy({
        where: {id: tryToken.id}
      })
    }

    const tempuser = await User.findOne({
      where: {
        login_id: loginFromDB.id,
      },
    })

    await Token.create({
      token: token,
      login_id: loginFromDB.id,
      user_id: tempuser.id,
    });


    reply.status(200).send({token})
  } catch (error) {
    reply.status(500).send({ error: error.message });
  }
});

fastify.delete("/auth/logout", async (request, reply) => {
  const token = request.headers.token;
  try {
    const tokenFromDB = await Token.findOne({
      where: {
        token: token,
      },
    });
    if (!tokenFromDB) {
      reply.status(404).send({ message: "token not Found" });
      throw new Error("token not Found");
    }
    
    await Token.destroy({
      where:{
        token: token,
      }
    });
  
    reply.status(200).send({ message: "Okey" })
  } catch (error) {
    reply.status(500).send({ error: error.message });
  }
});

fastify.get("/logins", async(request,reply) =>{
  try{
    const LogList = await Logins.findAll()
    reply.send(LogList);
  }catch(error){
    reply.status(500).send({error:error.message})
  }
})

fastify.post("/mark", async (request,reply) => {
  try{
    const temptoken = await Token.findOne({
      where: {token: request.headers.token}
    })
  
  await Mark.create({
    user_id: temptoken.user_id,
    place_id: request.body.place_id,
    label: request.body.label,
  })
  reply.status(201);
}catch(error){
  console.log(error.message)
  reply.status(500).send({error:error.message})
}
})

fastify.get("/mark/like", async (request,reply) =>{
  try{
    const temptoken = await Token.findOne({
      where: {token: request.headers.token}
    })
    const PlacesList = await sequelize.query("select * from find_like("+temptoken.user_id+");",{ type: QueryTypes.SELECT })
    reply.send({PlacesList})
  }catch(error){
    reply.status(500).send({error:error.message})
  }
})

fastify.get("/mark/blacklist", async (request,reply) =>{
  try{
    const temptoken = await Token.findOne({
      where: {token: request.headers.token}
    })
    const PlacesList = await sequelize.query("select * from find_blacklist("+temptoken.user_id+");",{ type: QueryTypes.SELECT })
    reply.send({PlacesList})
  }catch(error){
    reply.status(500).send({error:error.message})
  }
})

fastify.post("/places", async (request, reply) => {
  try {
      const places = await Places.create({
      title: request.body.title,
      description: request.body.description,
      pointlan: request.body.pointlan,
      pointlon: request.body.pointlon,
    });
    reply.send(places).status(200);
  } catch (error) {
    reply.status(500).send({ error: error.message });
  }
});

fastify.get("/places", async (request,reply) =>{
  try{
    const temptoken = await Token.findOne({
      where: {token: request.headers.token}
    })
    const PlacesList = await sequelize.query("select * from get_all_places("+temptoken.user_id+");",{ type: QueryTypes.SELECT })
    reply.send({PlacesList})
  }catch(error){
    reply.status(500).send({error:error.message})
  }
})

fastify.patch("/mark", async(request,reply) => {
  try{
    const temptoken = await Token.findOne({
      where: {token: request.headers.token}
    })
    await sequelize.query("begin")
    await sequelize.query("savepoint save;")
    await sequelize.query("call set_label("+temptoken.user_id+","+request.body.place_id+",'"+request.body.label+"');")
    await sequelize.query("commit;")
    reply.status(202)
  }catch(error){
    await sequelize.query("rollback to savepoint save;")
    await sequelize.query("commit;")
    reply.status(500).send({error:error.message})
  }
})

fastify.post("/review", async (request, reply) => {
  try {
    const temptoken = await Token.findOne({
      where: {token: request.headers.token}
    })
      const reView = await ReView.create({
      title: request.body.title,
      description: request.body.description,
      user_id: temptoken.user_id,
      place_id: request.body.place_id,
    });
    reply.send(reView).status(200);
  } catch (error) {
    reply.status(500).send({ error: error.message });
  }
});

fastify.get("/places/:id/reviews", async (request, reply) => {
  try {
    await sequelize.query("begin")
    const review = await sequelize.query("select * from reviews where place_id ="+request.params.id+";",{
    model: ReView,
    mapToModel:true
  })
    await sequelize.query("create temp table tt (id integer, title character varying, "+
    "description character varying, user_id integer, place_id integer)"+
    " on commit preserve rows;")
    await sequelize.query("commit;")
  reply.send(review);
  } catch (error) {
    reply.status(500).send({ error: error.message });
  }
});

fastify.get("/user/reviews", async (request, reply) => {
  try {
    const temptoken = await Token.findOne({
      where: {token: request.headers.token}
    })
  const review = await sequelize.query("select get_reviews_byuser("+temptoken.user_id+");",{
    model: ReView,
    mapToModel:true
  })
  reply.send(review);
  } catch (error) {
    reply.status(500).send({ error: error.message });
  }
});

fastify.get("/review/:id", async (request, reply) => {
  try {
  const review = await ReView.findByPk(request.params.id)
  reply.send(review);
  } catch (error) {
    reply.status(500).send({ error: error.message });
  }
});

fastify.delete("/review/:id", async (request, reply) => {
  try {
    await ReView.destroy({
      where: {id: request.params.id}
    })
  } catch (error) {
    reply.status(500).send({ error: error.message });
  }
});

fastify.get("/user", async (request, reply) => {
  try {
    const temptoken = await Token.findOne({
      where: {token: request.headers.token}
    })
  const user = await User.findByPk(temptoken.user_id)
  if(user){
  reply.send({user});
  }else{reply.status(404)}
  } catch (error) {
    reply.status(500).send({ error: error.message });
  }
});


// Run the server!
const start = async () => {
  try {
    await fastify.listen({ port: 8081 });
  } catch (err) {
    fastify.log.error(err);
    process.exit(1);
  }
};
start();
