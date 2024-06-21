import './App.scss'
import AdminRouter from './components/sections/AdminPanelSection/AdminRouter'
import { Route, useLocation, Routes } from 'react-router-dom'
import HomeSection from './components/sections/HomeSection.tsx'
import Header from './components/content/Header.tsx'
import ProductSection from './components/sections/ProductSection.tsx'
import ThankYouSection from './components/sections/ThankYouSection/ThankYouSection'
import Login from './components/sections/Login/Login.tsx'

function App() {
  return (
    <>
      {<Header />}
      <Routes location={location} key={location.pathname}>
        <Route path="/" element={<HomeSection />} />
        <Route path="/product" element={<ProductSection />} />
        <Route path="/thankYou" element={<ThankYouSection />} />
        <Route path="/login" element={<Login />} />
      </Routes>
    </>
  )
}

export default App
