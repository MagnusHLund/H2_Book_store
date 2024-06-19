import './Button.scss'
import React from 'react'
import { StandardInputProps } from './StandardInputProps'

interface IButton extends StandardInputProps {
  placeholder?: string
}

const Button: React.FC<IButton> = ({ placeholder = '', onClick }) => {
  return (
    <button className="button" onClick={onClick}>
      {placeholder}{' '}
    </button>
  )
}

export default Button
