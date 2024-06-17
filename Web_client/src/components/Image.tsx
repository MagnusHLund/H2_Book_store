import './Image.scss'

interface IImage {
    imageSrc?: string
}

const Image: React.FC<IImage> = ({ imageSrc }) => {
    return (
        <img src={ imageSrc }   className="image" />
    )
}

export default Image