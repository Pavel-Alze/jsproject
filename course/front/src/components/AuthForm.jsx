import '../styles/index.css'
import {Link, useNavigate} from 'react-router-dom'
import React from 'react';
import { Button, Form, Input } from 'antd';
import axios, { Axios } from "axios"

function AuthForm(){
    
    const navigate=useNavigate();
    const onFinish = (values) => {
        const user = axios.post("http://localhost:8081/auth/login", {
            login: values.login,
            password: values.password,
          }).then((response)=>{
            localStorage.setItem('token', response.data.token)
            console.log(localStorage.getItem("token"))
            if(response.status === 200){
              navigate('/main');
          }
          })
      };
      
      const onFinishFailed = (errorInfo) => {
        console.log('Failed:', errorInfo);
      };

    return(
      <div className='auth_wrapper'>
        <div className='auth_reg_block'> 
          <Form className='form_box'
              name="basic"
          onFinish={onFinish}
          onFinishFailed={onFinishFailed}
          autoComplete="off"
          >
            <Form.Item
              name="login"
              rules={[{ required: true, message: 'Please input your username!' }]}
            >
              <Input className='form_field' placeholder="Логин"/>
            </Form.Item>

            <Form.Item
              name="password"
              rules={[{ required: true, message: 'Please input your password!' }]}
            >
              <Input.Password className='form_field' placeholder="Пароль"/>
            </Form.Item>
    
            <Form.Item>
              <Button className='form_button' block type="primary" htmlType="submit">
                Войти
              </Button>
            </Form.Item>
          </Form>

        
      
        </div>
        <div className='register_link'>
          <Link to='/register'  className='register_link'>Нет аккаунта? Зарегистрироваться</Link>
        </div>
      </div>
    )      
}

export default AuthForm;