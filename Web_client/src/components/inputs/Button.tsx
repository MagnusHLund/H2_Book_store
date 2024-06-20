import './Button.scss'
import React from 'react'
import { StandardInputProps } from './StandardInputProps'

interface IButton extends StandardInputProps {
  placeholder?: string
  className?: string
}

const Button: React.FC<IButton> = ({
  placeholder = '',
  onClick,
  className = '',
}) => {
  return (
    <button className={`button ${className}`} onClick={onClick}>
      {placeholder}
    </button>
  )
}

export default Button
