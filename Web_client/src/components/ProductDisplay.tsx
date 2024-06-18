import './ProductDisplay.scss'
import Image from './Image'
import Button from './Button'

const numberOfProducts = 7

const ProductDisplay: React.FC = () => {
    return (
        <div className='products-container'>
        <section className="products-container__product-display">
            {Array.from({ length: numberOfProducts }, () => (
            <div className='products-container__product-display__box'>
                <Image imageSrc='https://cdn.kobo.com/book-images/5fc4252b-1c4f-40ef-9975-22982c94f12c/1200/1200/False/hamlet-prince-of-denmark-23.jpg'/>
                <div className='products-container__product-display__box__options-container'>
                    <h1> Hamlet by Shakespeare</h1>
                    <h2> 20$ </h2>
                    <Button placeholder='Add to Cart'/>
                </div>
            </div>
            ))}
        </section>
        </div>
    )
}

export default ProductDisplay