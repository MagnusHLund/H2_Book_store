import React from 'react';
import { NavLink } from 'react-router-dom';
import './Navbar.scss';

export type NavbarLink = {
  title: string;
  route: string;
  image?: string;
};

interface NavbarProps {
  links: NavbarLink[];
  className?: string;
}

const Navbar: React.FC<NavbarProps> = ({ links, className = '' }) => {
  return (
    <nav className={`navbar ${className}`}>
      <ul className="navbar__list">
        {links.map((link) => (
          <li className="navbar__item" key={link.title}>
            <NavLink
              to={link.route}
              className={({ isActive }) =>
                `navbar__link ${isActive ? 'navbar__link--active' : ''}`
              }
            >
              {link.image && (
                <img
                  src={link.image}
                  alt={`${link.title} icon`}
                  className="navbar__link-image"
                />
              )}
              {link.title}
            </NavLink>
          </li>
        ))}
      </ul>
    </nav>
  );
};

export default Navbar;
