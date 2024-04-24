import './scss/App.scss'
import { Route, useLocation, Routes } from "react-router-dom";
import Home from './Sections/Home'

function App() {
  const location = useLocation();

  let navlinks = [
    { name: "Home" , path: "/" },
    { name: "Login" , path: "/login" },
  ];

  return <>
    <Routes location={location} key={location.pathname}>
      <Route path="/" element={<Home/>} />
    </Routes>
  </>
}

export default App
