import { useState } from 'react'
import './Login.scss'

const Login: React.FC = () => {
  const [username, setUsername] = useState('')
  const [password, setPassword] = useState('')

  const handleUsernameChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setUsername(e.target.value)
  }

  const handlePasswordChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setPassword(e.target.value)
  }

  const handleLoginClick = () => {
    console.log('Login button clicked')
    console.log('Username:', username)
    console.log('Password:', password)
  }

  return (
    <div className="login-page">
      <form className="login-page__form">
        <div className="login-page__form-group">
          <label className="login-page__form-label">Username:</label>
          <input
            type="text"
            className="login-page__form-input"
            placeholder="Enter your username"
            value={username}
            onChange={handleUsernameChange}
          />
        </div>
        <div className="login-page__form-group">
          <label className="login-page__form-label">Password:</label>
          <input
            type="password"
            className="login-page__form-input"
            placeholder="Enter your password"
            value={password}
            onChange={handlePasswordChange}
          />
        </div>
        <button
          type="button" // Use type="button" to prevent form submission
          className="login-page__form-button"
          onClick={handleLoginClick}
        >
          Login
        </button>
      </form>
    </div>
  )
}

export default Login
