import '../styles/index.css'
import { BrowserRouter, Routes, Route } from "react-router-dom";
import ToDoTable from './ToDoTable'
import AuthForm from './AuthForm'
import RegisterForm from './RegisterForm';
import Main from './Main';
import Profile from './Profile';
import SearchPage from './SearchPage';

function Content(){
    return(
        <Routes>
            <Route path='todos' element={<div className='content'><ToDoTable/></div>}/>
            <Route path='/' element={<div className='content'><AuthForm/></div>}/>
            <Route path='register' element={<div className='content'><RegisterForm/></div>}/>
            <Route path='main' element={<div className='content'><Main/></div>}/>
            <Route path='profile' element={<div className='content'><Profile/></div>}/>
            <Route path='search' element={<div className='content'><SearchPage/></div>}/>
        </Routes>
    );
}
export default Content;