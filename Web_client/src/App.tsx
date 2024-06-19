import './App.scss'
import { Route, useLocation, Routes } from 'react-router-dom'
import Home from './components/sections/HomeSection.tsx'
import Header from './components/content/Header.tsx'
import ThankYouSection from './components/sections/ThankYouSection.tsx'

function App() {
  const location = useLocation()

  const navlinks = [
    { name: 'Home', path: '/' },
    { name: 'Login', path: '/login' },
  ]

  return (
    <>
      <Header />
      <Routes location={location} key={location.pathname}>
        <Route path="/" element={<Home />} />
        <Route path="/thankyou" element={<ThankYouSection />} />
      </Routes>
    </>
  )
}

export default App
