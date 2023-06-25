import '../styles/index.css'
import React from 'react';
import { Button, Form, Input } from 'antd';
import { Navigate, BrowserRouter, Routes, Route, Link, Router, useNavigate } from "react-router-dom";
import axios, { Axios } from "axios"
import ToDoTable from './ToDoTable';
import AuthForm from './AuthForm';
import { render } from 'react-dom';
import { Content } from 'antd/es/layout/layout';


function RegisterForm(){

    const navigate=useNavigate();
    const onFinish = async (values) => {
        try{
            await axios.post("http://localhost:8081/auth/registration", {
            login: values.login,
            password: values.password,
            name: values.name,
            surname: values.surname,
            phone: values.phone,
            email: values.email,
            age: values.age,
          }).then(function (response) {
            console.log(response.status);
            if(response.status === 200){
                navigate('/');
            }
          })
        }catch(err){
            console.log(err)
        }
      };
      
      const onFinishFailed = (errorInfo) => {
        console.log('Failed:', errorInfo);
      };

    return(
      <div className='auth_reg_block'>
            <Form className='form_box'
            name="basic"
            onFinish={onFinish}
            onFinishFailed={onFinishFailed}
            autoComplete="off"
            >
              <Form.Item
                name="name"
                rules={[{ required: true, message: 'Поле является обязательным!'}]}
              >
                <Input className='form_field' placeholder="Имя"/>
              </Form.Item>
              <Form.Item
                name="surname"
                rules={[{ required: true, message: 'Поле является обязательным!'}]}
              >
                <Input className='form_field' placeholder="Фамилия"/>
              </Form.Item>
              <Form.Item
                name="phone"
                rules={[{ required: true, message: 'Поле является обязательным!'}]}
              >
                <Input className='form_field' placeholder="Номер телефона"/>
              </Form.Item>
              <Form.Item
                name="email"
                rules={[{ required: true, message: 'Поле является обязательным!'}]}
              >
                <Input className='form_field' placeholder="Почта"/>
              </Form.Item>
              <Form.Item
                name="age"
                rules={[{ required: true, message: 'Поле является обязательным!'}]}
              >
                <Input className='form_field' placeholder="Возраст"/>
              </Form.Item>
              <Form.Item
                name="login"
                rules={[{ required: true, message: 'Поле является обязательным!'}]}
              >
                <Input className='form_field' placeholder="Логин"/>
              </Form.Item>

              <Form.Item
                name="password"
                rules={[{ required: true, message: 'Поле является обязательным!' }]}
              >
                <Input.Password className='form_field' placeholder="Пароль"/>
              </Form.Item>
      
              <Form.Item>
                <Button className='form_button' block type="primary" htmlType="submit" >
                  Зарегистрироваться
                </Button>
              </Form.Item>
            </Form>
      </div>
        
    )
}
export default RegisterForm;