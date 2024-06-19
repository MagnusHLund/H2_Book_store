import React from 'react'
import './ThankU.scss'

function ThankUText(){
  return (
    <div className="thank-you-customer">
        <label  className="thank-you">Thank you for choosing David's Book Store!</label>
        <label className="customer">Email sent CUSTOMER_NAME</label>
        <label className="order">Your order number is ORDER_NUMBER</label>
    </div>
  )
}

export default ThankUText
