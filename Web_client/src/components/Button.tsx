import '../scss/Button.scss'
import React from 'react'

interface IButton {
    placeholder?: string
}

const Button: React.FC<IButton> = ({ placeholder }) => {
    return (
        <button className="button"> { placeholder } </button>
    )
}

export default Button