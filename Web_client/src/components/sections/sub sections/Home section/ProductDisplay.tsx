import React from 'react'
import './ProductDisplay.scss'
import Product from './Product'

const ProductDisplay: React.FC = () => {
    const numberOfProducts = [{ productId: 1 }, { productId: 2 }, { productId: 3 }, { productId: 4 } , { productId: 5 }, { productId: 6 }, { productId: 7 }, { productId: 8 }]

    return (
        <div className="products-container">
            <section className="products-container__product-display">
                {numberOfProducts.map((product) => (
                    <Product key={product.productId} product={product} />
                ))}
            </section>
        </div>
    )
}

export default ProductDisplay
