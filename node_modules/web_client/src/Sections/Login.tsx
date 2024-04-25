import React, { useState } from "react";
import "../scss/Login.scss"; // Import your SCSS file
import Button from "../components/Button";
import { Link } from "react-router-dom";

const LoginPage: React.FC = () => {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");

  const handleLogin = (e) => {
    e.preventDefault();
    console.log("Email:", email);
    console.log("Password:", password);
  };

  return (
    <div className="main">
      <div className="logoside">
        <img
          className="logo"
          src="https://www.w3schools.com/tags/img_girl.jpg"
          alt="Micheal Logo"
        ></img>
      </div>
      <div className="content">
        <div className="login-card">
          <h1>Log på med din mailadresse</h1>
          <form onSubmit={handleLogin}>
            <div className="input-container">
              <label htmlFor="emailaddress">Mailadresse</label>
              <input
                id="emailaddress"
                type="email"
                placeholder="Email"
                value={email}
                required
                onChange={(e) => setEmail(e.target.value)}
              />
              <label htmlFor="password">Adgangskode</label>
              <input
                id="password"
                type="password"
                placeholder="Password"
                value={password}
                required
                onChange={(e) => setPassword(e.target.value)}
              />
            </div>
            <div className="align-btn">
              <Button type="submit" placeholder="Login" />
            </div>
          </form>
          <p>
            Har du ikke en profil?{" "}
            <Link className="link" to="sign_up">
              Opret profil med e-mail her.
            </Link>
          </p>
        </div>
      </div>
    </div>
  );
};

export default LoginPage;
