import React from "react"
import Image from './Image.tsx'
import './BasketItem.scss'
interface BasketItemProps {
    quantity?: number, 
    name?: string,
    price?: number,
    productId?: number
}

const BasketItem : React.FC<BasketItemProps>  = () => {

    const numberOfItems = [{ productId: 1 }, { productId: 2 }, { productId: 3 },]
 
    return (
        <>
            <div className='basket-item'>
                {numberOfItems.map((product) => (
                    <div key={product.productId} className='basket-item__product'>
                        <Image imageSrc="https://cdn.kobo.com/book-images/6b612cbd-e4d2-45ab-ba05-be6f8e99c070/353/569/90/False/star-wars-original-trilogy-graphic-novel.jpg"/>
                        <p className='product-id'>Product ID: {product.productId}</p>
                    </div>
                ))}
            </div>
        </>
    )
}


export default BasketItem