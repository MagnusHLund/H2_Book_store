import './App.scss'
import { Route, useLocation, Routes } from "react-router-dom";
import Home from './components/sections/Home'
import Header from "./components/Header.tsx";

function App() {
  const location = useLocation();

  const navlinks = [
    { name: "Home" , path: "/" },
    { name: "Login" , path: "/login" },
  ];

  return <>
    <Header/>
    <Routes location={location} key={location.pathname}>
      <Route path="/" element={<Home/>} />
    </Routes>
  </>
}

export default App
