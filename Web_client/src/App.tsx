import './App.scss'
import { Route, useLocation, Routes } from 'react-router-dom'
import HomeSection from './components/sections/HomeSection.tsx'
import Header from './components/content/Header.tsx'
import ThankYouSection from './components/sections/ThankYouSection/ThankYouSection'
import Login from './components/sections/Login/Login.tsx'

function App() {
  const location = useLocation()

  const navlinks = [
    { name: 'Home', path: '/' },
    { name: 'Login', path: '/login' },
  ]

  return (
    <>
      {/* <Header /> */}
      <Routes location={location} key={location.pathname}>
        <Route path="/" element={<HomeSection />} />
        <Route path="/thankYou" element={<ThankYouSection />} />
        <Route path="/login" element={<Login />} />
      </Routes>
    </>
  )
}

export default App
