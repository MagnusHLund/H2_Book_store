import './ProductDisplay.scss'
import Image from './Image'
import Button from './Button'

const numberOfProducts = 7

const ProductDisplay: React.FC = () => {
    return (
        <div className='productsContainer'>
        <section className="productsContainer__productDisplay">
            {Array.from({ length: numberOfProducts }, () => (
            <div className='productsContainer__productDisplay__box'>
                <Image imageSrc='https://cdn.kobo.com/book-images/5fc4252b-1c4f-40ef-9975-22982c94f12c/1200/1200/False/hamlet-prince-of-denmark-23.jpg'/>
                <div className='productsContainer__productDisplay__box__optionsContainer'>
                    <h1> Hamlet by Shakespeare</h1>
                    <h2> 20$ </h2>
                    <Button placeholder='Buy'/>
                </div>
            </div>
            ))}
        </section>
        </div>
    )
}

export default ProductDisplay