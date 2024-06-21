import './Image.scss'

interface IImage {
    imageSrc: string
    description: string
    className?: string
}

const Image: React.FC<IImage> = ({ imageSrc , description, className = "" }) => {
    return (
        <img src={ imageSrc } alt={ description } className={`image ${className}`}/>
    )
}

export default Image