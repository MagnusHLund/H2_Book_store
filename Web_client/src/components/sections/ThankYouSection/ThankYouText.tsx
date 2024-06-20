import React from 'react';
import './ThankYouSection.scss';
import Button from './../../inputs/Button.tsx';
import BoughtProducts from './BoughtProducts.tsx';
import SectionWithTitle from '../../sections/sub sections/SectionWithTitle.tsx';

const ThankYouSection = () => {
  return (
    <div className="thank-you">
      <SectionWithTitle title="Thank you for choosing David's Book Store!">
        <p>Email sent CUSTOMER_NAME</p>
        <p>Your order number is ORDER_NUMBER</p>
      </SectionWithTitle>
      <BoughtProducts />
      <div className="thank-you__button-container">
        <Button placeholder='Home' className="thank-you__button" />
      </div>
    </div>
  );
}

export default ThankYouSection;
