import './Image.scss'

interface IImage {
    imageSrc?: string
    description?: string
}

const Image: React.FC<IImage> = ({ imageSrc , description }) => {
    return (
        <img src={ imageSrc } alt={ description } className="image" />
    )
}

export default Image