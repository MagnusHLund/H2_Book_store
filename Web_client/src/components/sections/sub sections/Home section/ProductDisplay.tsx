import React from 'react'
import Image from '../../../content/Image'
import Button from './../../../inputs/Button'

const ProductDisplay: React.FC = () => {
  const numberOfProducts = [{ productId: 1 }, { productId: 2 }]

  return (
    <div className="products-container">
      <section className="products-container__product-display">
        {numberOfProducts.map((product) => (
          <div
            key={product.productId}
            className="products-container__product-display__box"
          >
            <Image imageSrc="https://cdn.kobo.com/book-images/5fc4252b-1c4f-40ef-9975-22982c94f12c/1200/1200/False/hamlet-prince-of-denmark-23.jpg" />
            <div className="products-container__product-display__box__options-container">
              <h1>Hamlet by Shakespeare</h1>
              <h2>20$</h2>
              <Button placeholder="Add to Cart" />
            </div>
          </div>
        ))}
      </section>
    </div>
  )
}

export default ProductDisplay
