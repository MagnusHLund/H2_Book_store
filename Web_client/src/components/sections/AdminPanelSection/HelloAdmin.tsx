import React from 'react';
import "./HelloAdmin.scss";
import Image from './../../content/Image';

function HelloAdmin() {
    const INSERTADMINNAME = "admin_test";
  return (
    <div className="hello-admin-section">
        <h1 className="h1-admin-hello">Hello {INSERTADMINNAME}</h1>
        <Image imageSrc="/DavidsBookClub.png" description='Davids book club logo' className="davids-book-club-logo" />
    </div>
  );
}

export default HelloAdmin;
