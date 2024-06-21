import React from 'react';
import Navbar, { NavbarLink } from './../../content/Navbar';

const links: NavbarLink[] = [
  { title: 'Se kunde ordre', route: '#orders' },
  { title: 'Administrer produkter', route: '#manage-products' },
  { title: 'Tilbage til shoppen', route: '#shop' }
];

function App() {
  return (
    <div>
      <Navbar links={links} className="admin-navbar" />
      
    </div>
  );
}

export default App;
