import './Button.scss'
import React, {ReactNode} from 'react'
import cn from 'classnames'

interface IButton {
    placeholder?: string
    onClick?: () => void
    transparent?: boolean
    className? : string
    children?: ReactNode
}

const Button: React.FC<IButton> = ({ placeholder = "", onClick  , transparent = false, className = 'button', children =''}) => {
    
    const fullClassName = cn(`${className}`, {
        transparent: transparent,
    })
    
    return (
        <button className={fullClassName} onClick={onClick}> { children } { placeholder } </button>
      )
}

export default Button