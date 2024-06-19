import React from 'react';
import './AdminNavbar.scss';

function AdminNavbar() {
  return (
    <nav className="admin-navbar">
      <ul className="admin-navbar__list">
        <li className="admin-navbar__item">
          <a href="#orders" className="admin-navbar__link">Se kunde ordre</a>
        </li>
        <li className="admin-navbar__item">
          <a href="#manage-products" className="admin-navbar__link">Administrer produkter</a>
        </li>
        <li className="admin-navbar__item">
        <a href="#shop" className="admin-navbar__link"> &gt; Tilbage til shoppen</a>
        </li>
      </ul>
    </nav>
  );
}

export default AdminNavbar;
