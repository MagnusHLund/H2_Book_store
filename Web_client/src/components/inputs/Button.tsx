import './Button.scss'
import React from 'react'

interface IButton {
    placeholder?: string
    className?: string
}

const Button: React.FC<IButton> = ({ placeholder = "" }, {className = ""}) => {
    return (
        <button className= {`button${className}`}> { placeholder }</button>
    )
}

export default Button