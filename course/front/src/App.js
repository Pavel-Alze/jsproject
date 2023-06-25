import { BrowserRouter, Routes, Route } from "react-router-dom";
import ToDoTable from "./components/ToDoTable";
import Header from "./components/Header";
import Content from "./components/Content";
import SiteFooter from "./components/SiteFooter";
import { Footer } from "antd/es/layout/layout";

function App() {
return [
    <div className="full">
    <Header/>
    <Content/>
    <SiteFooter/>
    </div>
];
}

export default App;