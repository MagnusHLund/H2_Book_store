import './App.scss'
import AdminRouter from './components/sections/AdminPanelSection/AdminRouter'
import { Route, useLocation, Routes } from 'react-router-dom'
import HomeSection from './components/sections/HomeSection.tsx'
import Header from './components/content/Header.tsx'
import ThankYouSection from './components/sections/ThankYouSection/ThankYouSection'

function App() {
  return (
    <>
      <Header />
      <Routes location={location} key={location.pathname}>
        <Route path="/" element={<HomeSection />} />
        <Route path="/thankYou" element={<ThankYouSection />} />
      </Routes>
    </>
  )
}

export default App
