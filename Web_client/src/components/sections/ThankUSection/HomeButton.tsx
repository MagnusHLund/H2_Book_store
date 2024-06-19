import React from 'react';
import './HomeButton.scss';

function HomeButton() {
  const handleClick = () => {

  };

  return (
    <div className="home-button-container">
      <button className="home-button" onClick={handleClick}>
        Home
      </button>
    </div>
  );
}

export default HomeButton;
