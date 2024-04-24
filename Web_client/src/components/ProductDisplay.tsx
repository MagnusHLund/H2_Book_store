import '../scss/ProductDisplay.scss'
import Image from './Image'

interface IProductDisplay {
}

const ProductDisplay: React.FC<IProductDisplay> = () => {
    return (
        <section  className="productDisplay">
            <div className='productDisplay__box'>
                <Image imageSrc='https://cdn.kobo.com/book-images/5fc4252b-1c4f-40ef-9975-22982c94f12c/1200/1200/False/hamlet-prince-of-denmark-23.jpg'/>
            </div>
        </section>
    )
}

export default ProductDisplay