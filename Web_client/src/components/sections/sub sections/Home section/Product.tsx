import React from 'react'
import './Product.scss'
import Image from '../../../content/Image'
import Button from '../../../inputs/Button'

interface ProductProps {
    product: {
        productId: number
    }
}

const Product: React.FC<ProductProps> = ({ product }) => {
    return (
        <div key={product.productId} className="product">
            <Image
                imageSrc="https://cdn.kobo.com/book-images/5fc4252b-1c4f-40ef-9975-22982c94f12c/1200/1200/False/hamlet-prince-of-denmark-23.jpg"
            />
            <div className="product__options-container">
                <h1>Hamlet by Shakespeare</h1>
                <h2>20$</h2>
                <Button placeholder="Add to Basket" />
            </div>
        </div>
    )
}

export default Product
